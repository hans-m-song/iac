#!/bin/bash
set -eo pipefail

brew install helm helmfile

plugins=(
  https://github.com/aslafy-z/helm-git
  https://github.com/databus23/helm-diff
)

for plugin in ${plugins[@]}; do
  helm plugin install $plugin || true
done

helmfile repos
helmfile deps
