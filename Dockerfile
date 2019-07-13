FROM ubuntu:18.04

# Setup essentials for other installers
RUN apt-get update \
    && apt-get install -y curl git 

# Setup python
RUN apt-get install -y python python-dev python-pip
RUN apt-get install -y python3 python3-dev python3-pip
RUN apt-get install -y build-essential zlib1g-dev libncurses5-dev libbz2-dev libsqlite3-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev
RUN pip install pipenv
RUN git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv \
    && chmod +x $HOME/.pyenv \
    && ln -s $HOME/.pyenv/bin/pyenv /usr/local/bin/pyenv
ENV PYTHON_VERSION=3.7.2
RUN pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

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
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x kubectl

CMD ["/bin/bash"]
