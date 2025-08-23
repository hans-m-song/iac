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

ARG GH_VERSION=2.78.0
RUN curl -fsSLo ./gh.tar.gz \
  https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz \
  && sudo tar -xzf gh.tar.gz -C /usr/local/bin/ --strip-components=2 gh_${GH_VERSION}_linux_amd64/bin/gh \
  && sudo chmod 555 /usr/local/bin/gh \
  && rm gh.tar.gz

# kubectl
# https://cdn.dl.k8s.io/release/stable.txt
ARG KUBECTL_VERSION=1.31.2
RUN sudo curl -fsSLo /usr/local/bin/kubectl \
  "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && sudo chmod 555 /usr/local/bin/kubectl
