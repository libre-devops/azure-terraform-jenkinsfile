FROM jenkins/jenkins:latest

ENV NORMAL_USER jenkins

USER root

LABEL org.opencontainers.image.source=https://github.com/libre-devops/azure-terraform-jenkins-container

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

#Install needed packages as well as setup python with args and pip
RUN apt-get update -y && apt-get dist-upgrade -y && apt-get install -y \
    apt-transport-https \
    bash \
    ca-certificates \
    curl \
    gcc \
    git  \
    sudo \
    software-properties-common \
    unzip \
    wget \
    zip  \
    zlib1g-dev && \
                useradd -m -s /bin/bash linuxbrew && \
                usermod -aG sudo linuxbrew &&  \
                mkdir -p /home/linuxbrew/.linuxbrew && \
                chown -R linuxbrew: /home/linuxbrew/.linuxbrew

#Set User Path with expected paths for new packages
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin:/usr/local/go:/usr/local/go/dev/bin:/usr/local/bin/python3:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.local/bin:${PATH}"
RUN echo $PATH | tee /etc/environment

USER linuxbrew

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/linuxbrew/.bash_profile && \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/linuxbrew/.bashrc && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

RUN brew install tfsec python3 tfenv tree
RUN pip3 install terraform-compliance checkov && \
    tfenv install latest

USER ${NORMAL_USER}

ENV PATH="/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/jenkins_home/.local/bin:${PATH}"

RUN  pip3 install checkov && \
            pip3 install --upgrade checkov && \
                pip3 install azure-cli && \
                pip3 install --upgrade azure-cli && \
                    pip3 install terraform-compliance && \
                    pip3 install --upgrade terraform-compliance
