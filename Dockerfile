FROM ubuntu:18.04

# Setup essentials for other installers
RUN apt-get update \
    && apt-get install -y python python3 \
    && apt-get install -y curl \
    && apt-get install -y git

# Setup python
RUN pip install pipenv

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
ENV KUBECTL_VERSION=1.15.0
RUN cd /usr/local/bin && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x kubectl

CMD ["/bin/bash"]
