# ARC upgrade preparation

Use the Bash helper during an upgrade window, then reapply Helmfile:

```bash
bash k8s/collections/deployment/prepare-upgrade.sh --context YOUR_CONTEXT
bash k8s/collections/deployment/prepare-upgrade.sh --context YOUR_CONTEXT --execute
```

The first command checks the selected cluster and prints the proposed scope. The second performs preparation. Dependencies: Bash, Helm, kubectl, jq, and rg. Chart versions and release names come from the literal fields in this collection's Helmfile; the script does not render it or read project secrets.

Execution follows one sequence:

1. Download the target chart's CRDs and reject unexpected ARC releases, CRDs, or runner sets.
2. Check controller availability; set runner limits to zero and wait for runner resources and pods to disappear.
3. Uninstall runner-set releases and wait for ARC resource/listener cleanup.
4. Uninstall the controller and wait for its pods to disappear.
5. Delete the empty ARC CRDs and print the context-bound Helmfile reapply command.

The support Secret and cache PVC are preserved. Preparation always uses this cleanup/reinstall sequence; it does not compare schemas or maintain checkpoints. Use it for upgrades, rather than routine Helmfile applies.

Keep other deployment automation paused, and run the script outside the ARC runners being upgraded. Runner downtime lasts until you reapply Helmfile. Afterward, verify controller/listener health, metrics, and a representative workflow on each runner set.

Waits and Helm uninstalls default to 1800 seconds; use `--timeout SECONDS` to change that. A failed command or timeout stops the script. Inspect the remaining resources before retrying: runner limits may remain zero and some releases may already be removed. Partial CRD deletion requires inspection; the script refuses an incomplete CRD inventory. It does not force finalizers.

Runner images track `latest`. The publishing workflow requests a fresh upstream base image on each monthly, push-triggered, or manual build, and runner pods use `imagePullPolicy: Always`. The preparation script does not build or publish images.

Reviewed on 2026-10-05 against [GitHub's upgrade procedure](https://docs.github.com/en/actions/how-tos/manage-runners/use-actions-runner-controller/deploy-runner-scale-sets#upgrading-arc) and [maintenance drain configuration](https://docs.github.com/en/actions/how-tos/manage-runners/use-actions-runner-controller/deploy-runner-scale-sets#example-jobs-queue-draining). All four released CRD specifications differ between ARC 0.14.2 and 0.15.0.
