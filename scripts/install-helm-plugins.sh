#!/bin/bash
set -eo pipefail

plugins=(
  https://github.com/aslafy-z/helm-git
  https://github.com/databus23/helm-diff
)

for plugin in ${plugins[@]}; do
  helm plugin install $plugin || true
done
