FROM octopusdeploy/tentacle:latest

RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends \
  apt-transport-https \
  ca-certificates \
  curl \
  groff \
  jq \
  net-tools \
  unzip \
  xz-utils \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/*

# aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscli.zip" \
  && unzip -q awscli.zip \
  && sudo ./aws/install \
  && rm -rf aws awscli.zip \
  && export AWS_PAGER=""

# helm
RUN sudo curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
  && sudo chmod +x get_helm.sh \
  && ./get_helm.sh \
  && sudo rm ./get_helm.sh

# kubectl
ARG KUBECTL_VERSION="v1.26.1"
RUN sudo curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
  && sudo chmod +x /usr/local/bin/kubectl
