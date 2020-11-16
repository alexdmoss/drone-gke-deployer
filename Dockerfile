FROM ubuntu:18.04

# Setup essentials for other installers
RUN apt-get update && apt-get install -y \
  curl \
  ca-certificates \
  gettext-base \
  git \
  gnupg2 \
  less \
  openssh-client \
  shellcheck \
  unzip \
  apache2-utils \  
  wget

RUN apt-get install -y python python-dev python-pip \
    && apt-get install -y python3 python3-dev python3-pip \
    && pip install pipenv

RUN cd /usr/local/bin && \
  wget --no-verbose -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && \
  chmod +x jq

# Setup gcloud
ENV PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz \
    && mkdir -p /usr/local/gcloud \
    && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
    && /usr/local/gcloud/google-cloud-sdk/install.sh --quiet --usage-reporting=false --path-update=true --bash-completion=true --rc-path=/root/.bashrc \
    && gcloud config set --installation component_manager/disable_update_check true \
    && gcloud config set component_manager/disable_update_check true \
    && gcloud config set core/disable_usage_reporting true

# Setup kubectl
ENV KUBECTL_VERSION=1.16.3
RUN cd /usr/local/bin && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x kubectl

# Setup kustomize
ENV KUSTOMIZE_VERSION=3.0.0
ENV KUSTOMIZE_SHA256="ef0dbeca85c419891ad0e12f1f9df649b02ceb01517fa9aea0297ef14e400c7a kustomize"
RUN cd /usr/local/bin && \
    curl -sL -o kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64 && \
    echo "${KUSTOMIZE_SHA256}" | sha256sum --check --status && \
    chmod +x kustomize

# install gitbook
RUN apt-get install -y npm \
    && npm install gitbook-cli -g

# terraform via tfenv
ENV TFENV_AUTO_INSTALL=true
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && ln -s ~/.tfenv/bin/* /usr/local/bin \
    && mkdir ~/.tfenv/versions

CMD ["/bin/bash"]
