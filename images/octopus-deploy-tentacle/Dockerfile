FROM octopusdeploy/tentacle:latest

# helm
RUN sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  && sudo chmod +x get_helm.sh \
  && ./get_helm.sh \
  && sudo rm ./get_helm.sh

# kubectl
ARG KUBECTL_VERSION="v1.26.1"
RUN sudo curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && sudo chmod +x /usr/local/bin/kubectl
