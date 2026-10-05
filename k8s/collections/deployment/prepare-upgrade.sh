#!/usr/bin/env bash
set -euo pipefail

context=""
execute=false
timeout=1800
fail() { printf '%s\n' "$*" >&2; exit 1; }
while (($#)); do
  case "$1" in
    --context) (($# >= 2)) || fail "--context needs a name"; context=$2; shift 2 ;;
    --execute) execute=true; shift ;;
    --timeout) (($# >= 2)) || fail "--timeout needs seconds"; timeout=$2; shift 2 ;;
    --help) printf '%s\n' "Usage: bash prepare-upgrade.sh --context NAME [--execute] [--timeout SECONDS]"; exit 0 ;;
    *) fail "Unknown option: $1" ;;
  esac
done
[[ -n "$context" ]] || fail "--context is required"
[[ "$timeout" =~ ^[1-9][0-9]*$ ]] || fail "--timeout must be a positive integer"
for tool in helm kubectl jq rg; do command -v "$tool" >/dev/null || fail "Missing command: $tool"; done

directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
helmfile="$directory/helmfile.yaml.gotmpl"
releases=$(awk '
  function emit() {
    if (chart ~ /\/gha-runner-scale-set(-controller)?$/)
      print namespace "\t" name "\t" chart "\t" version
  }
  $1 == "-" && $2 == "name:" { emit(); name=$3; chart=namespace=version="" }
  $1 == "chart:" { chart=$2 }
  $1 == "namespace:" { namespace=$2 }
  $1 == "version:" { version=$2 }
  END { emit() }
' "$helmfile")
controller=$(printf '%s\n' "$releases" | awk '$3 ~ /\/gha-runner-scale-set-controller$/')
[[ -n "$controller" && "$controller" != *$'\n'* ]] || fail "Expected one literal ARC controller release"
IFS=$'\t' read -r controller_namespace controller_name controller_chart version <<< "$controller"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "Expected a literal stable ARC version"
expected=$(printf '%s\n' "$releases" | awk -v version="$version" '
  NF != 4 || $4 != version { exit 1 }
  { print $1 "\t" $2 }
') || fail "ARC releases must have matching literal chart versions"
runner_namespaces=$(printf '%s\n' "$releases" | awk '$3 ~ /\/gha-runner-scale-set$/ {print $1}' | sort --unique)
[[ -n "$runner_namespaces" && "$runner_namespaces" != *$'\n'* ]] || fail "Expected runner sets in one namespace"

kube() { kubectl --context "$context" --request-timeout=30s "$@"; }
wait_empty() {
  local deadline=$((SECONDS + timeout)) remaining
  while :; do
    remaining=$(kube get "$@" --output=name)
    [[ -z "$remaining" ]] && return
    ((SECONDS < deadline)) || fail "Timed out waiting for $*; inspect the cluster before retrying"
    sleep 5
  done
}
printf 'Context: %s\nTarget ARC version: %s\n' "$context" "$version"
installed=$(helm list --deployed --failed --pending --uninstalling --uninstalled --superseded --all-namespaces --max 10000 --output json --kube-context "$context" |
  jq --raw-output --arg controller "$controller_name" --arg namespace "$controller_namespace" '
    if type != "array" or length >= 10000 then error("invalid or truncated release inventory")
    else .[] | select(.chart | startswith("gha-runner-scale-set-")) |
      (if .name == $controller and .namespace == $namespace then "gha-runner-scale-set-controller" else "gha-runner-scale-set" end) as $chart |
      if (.chart | test("^" + $chart + "-[0-9]+\\.[0-9]+\\.[0-9]+$")) then [.namespace, .name] | @tsv
      else error("unexpected ARC chart identity: " + .chart) end
    end' || {
    fail "Unable to inventory ARC Helm releases"
  })
while IFS= read -r release; do
  [[ -z "$release" ]] && continue
  printf '%s\n' "$expected" | rg --fixed-strings --line-regexp --quiet -- "$release" || fail "Unexpected ARC installation: $release"
done <<< "$installed"

work_dir=$(mktemp -d)
trap 'rm -r -- "$work_dir"' EXIT
helm show crds "$controller_chart" --version "$version" --registry-config /dev/null > "$work_dir/crds.yaml"
crds=$(awk '/^  name: [a-z]+\.actions\.github\.com$/ {print $2}' "$work_dir/crds.yaml" | sort --unique)
[[ $(printf '%s\n' "$crds" | wc -l | tr -d ' ') == 4 ]] || fail "Expected the four ARC CRDs in the target chart"
installed_crds=$(kube get crds --output='jsonpath={range .items[?(@.spec.group=="actions.github.com")]}{.metadata.name}{"\n"}{end}')
while IFS= read -r crd; do
  [[ -z "$crd" ]] && continue
  printf '%s\n' "$crds" | rg --fixed-strings --line-regexp --quiet -- "$crd" || fail "Unexpected ARC CRD: $crd"
done <<< "$installed_crds"
if [[ -z "$installed_crds" ]]; then
  [[ -z "$installed" ]] || fail "ARC releases remain without CRDs; inspect the cluster before retrying"
  printf '%s\n' "No ARC CRDs installed; apply Helmfile directly."
  printf 'helmfile --kube-context %q --file %q --selector deployment=true sync\n' "$context" "$helmfile"
  exit 0
fi
[[ $(printf '%s\n' "$installed_crds" | wc -l | tr -d ' ') == 4 ]] || fail "ARC CRDs are incomplete; inspect the previous cleanup before retrying"
sets=$(kube get autoscalingrunnersets.actions.github.com --all-namespaces --output='jsonpath={range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\t"}{.metadata.annotations.meta\.helm\.sh/release-name}{"\n"}{end}')
while IFS=$'\t' read -r namespace name release; do
  [[ -z "$name" ]] && continue
  [[ "$namespace" == "$runner_namespaces" && -n "$release" ]] || fail "Unexpected ARC runner set: $namespace/$name"
  printf '%s\n' "$releases" | awk '$3 ~ /\/gha-runner-scale-set$/ {print $1 "\t" $2}' |
    rg --fixed-strings --line-regexp --quiet -- "$namespace"$'\t'"$release" || fail "Unexpected runner-set ownership: $namespace/$name"
  printf '%s\n' "$installed" | rg --fixed-strings --line-regexp --quiet -- "$namespace"$'\t'"$release" || fail "Runner set has no installed Helm release: $namespace/$name"
done <<< "$sets"
printf '%s\n' "ARC releases:" "$installed" "Runner sets:" "$sets"
printf 'After preparation: helmfile --kube-context %q --file %q --selector deployment=true sync\n' "$context" "$helmfile"
$execute || { printf '%s\n' "Checks only. Add --execute to drain and remove ARC for reinstallation."; exit 0; }

if [[ -n "$sets" ]]; then
  kube wait --for=condition=Available deployments --namespace "$controller_namespace" \
    --selector "app.kubernetes.io/instance=$controller_name,app.kubernetes.io/name=gha-rs-controller" --timeout=30s
fi

while IFS=$'\t' read -r namespace name release; do
  [[ -z "$name" ]] && continue
  kube patch autoscalingrunnersets.actions.github.com "$name" --namespace "$namespace" \
    --type=merge --patch '{"spec":{"minRunners":0,"maxRunners":0}}' --output=name
done <<< "$sets"
wait_empty ephemeralrunners.actions.github.com --all-namespaces
wait_empty pods --all-namespaces --selector actions-ephemeral-runner=true
while IFS=$'\t' read -r namespace name chart release_version; do
  [[ "$chart" == */gha-runner-scale-set ]] || continue
  printf '%s\n' "$installed" | rg --fixed-strings --line-regexp --quiet -- "$namespace"$'\t'"$name" || continue
  helm uninstall "$name" --namespace "$namespace" --kube-context "$context" --wait --timeout "${timeout}s"
done <<< "$releases"
resources=$(printf '%s\n' "$crds" | paste -sd ',' -)
wait_empty "$resources" --all-namespaces
wait_empty pods --all-namespaces --selector app.kubernetes.io/component=runner-scale-set-listener
if printf '%s\n' "$installed" | rg --fixed-strings --line-regexp --quiet -- "$controller_namespace"$'\t'"$controller_name"; then
  helm uninstall "$controller_name" --namespace "$controller_namespace" --kube-context "$context" --wait --timeout "${timeout}s"
fi
wait_empty pods --namespace "$controller_namespace" --selector "app.kubernetes.io/instance=$controller_name,app.kubernetes.io/name=gha-rs-controller"
wait_empty "$resources" --all-namespaces
while IFS= read -r crd; do
  kube delete crd "$crd" --wait=true --timeout "${timeout}s"
done <<< "$crds"
printf '%s\n' "Preparation complete. Reapply Helmfile using the command above."
