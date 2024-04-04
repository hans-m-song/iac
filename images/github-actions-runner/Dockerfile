FROM --platform=linux/amd64 summerwind/actions-runner-dind:ubuntu-22.04 

# SHELL ["/bin/bash", "--login", "-c"]
WORKDIR $HOME

RUN sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends \
  apt-transport-https \
  build-essential \
  ca-certificates \
  curl \
  groff \
  jq \
  less \
  libssl-dev \
  net-tools \
  openssl \
  python3 \
  python3-pip \
  unzip \
  wget \
  xz-utils \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/*

RUN sudo ln -sf /usr/bin/python3 /usr/bin/python \
  && sudo ln -sf /usr/bin/pip3 /usr/bin/pip \
  && pip install yq

# aws cli
RUN curl -fsSLo ./awscli.zip \
  https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
  && unzip -q awscli.zip \
  && sudo ./aws/install \
  && rm -rf aws awscli.zip \
  && export AWS_PAGER=""

# buildx
# https://github.com/docker/buildx/releases/latest
ARG DOCKER_BUILDX_VERSION=0.13.1
RUN mkdir -p $HOME/.docker/cli-plugins \
  && curl -fsSLo $HOME/.docker/cli-plugins/docker-buildx \
  https://github.com/docker/buildx/releases/download/v${DOCKER_BUILDX_VERSION}/buildx-v${DOCKER_BUILDX_VERSION}.linux-amd64 \
  && chmod +x $HOME/.docker/cli-plugins/docker-buildx \
  && chown -R runner:docker $HOME/.docker

# helm
# https://github.com/helm/helm/releases/latest
ARG HELM_VERSION=3.14.3
RUN sudo curl -fsSL \
  https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  | sudo tar --directory /usr/local/bin --strip-components 1 -xz linux-amd64/helm \
  && sudo chmod 555 /usr/local/bin/helm

# helmfile
# https://github.com/helmfile/helmfile/releases/latest
ARG HELMFILE_VERSION=0.163.1
RUN sudo curl -fsSL \
  https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_amd64.tar.gz \
  | sudo tar --directory /usr/local/bin -xz helmfile \
  && sudo chmod 555 /usr/local/bin/helmfile

# kubectl
# https://cdn.dl.k8s.io/release/stable.txt
ARG KUBECTL_VERSION=1.29.3
RUN sudo curl -fsSLo /usr/local/bin/kubectl \
  "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && sudo chmod 555 /usr/local/bin/kubectl
