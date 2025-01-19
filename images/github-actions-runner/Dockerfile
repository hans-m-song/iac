FROM --platform=linux/amd64 ghcr.io/actions/actions-runner:latest

RUN \
  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  sudo rm -f /etc/apt/apt.conf.d/docker-clean \
  && sudo apt-get update \
  && sudo apt-get install -y --no-install-recommends \
  build-essential \
  python3 \
  python3-pip \
  unzip \
  wget \
  xz-utils

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

# kubectl
# https://cdn.dl.k8s.io/release/stable.txt
ARG KUBECTL_VERSION=v1.31.2
RUN sudo curl -fsSLo /usr/local/bin/kubectl \
  "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && sudo chmod 555 /usr/local/bin/kubectl
