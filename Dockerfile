FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

ENV USER="root"

RUN apt-get --quiet update && \
    apt-get --quiet --yes upgrade && \
    apt-get --quiet --yes install \
		curl \
		openssh-client \
		git \
		python3 \
		python3-pip \
		python-is-python3 \
        software-properties-common \
 		sshpass \
		unzip

# Install Ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt-get --quiet --yes install ansible

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get --quiet update && \
    apt-get --quiet --yes install kubectl

# Install helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get --quiet --yes install helm
RUN apt-get clean all

# install python dependencies that I need for ansible
RUN pip install --upgrade pip kubernetes kubernetes-validate influxdb botocore boto3 netaddr passlib pymysql

# install galaxy collections
RUN ansible-galaxy collection install kubernetes.core community.mysql community.grafana

# install tfenv
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
RUN echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.bash_profile
ENV PATH="/root/.tfenv/bin:${PATH}"
RUN tfenv install 1.5.1
RUN tfenv use 1.5.1

# install terragrunt
RUN curl -L -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.56.3/terragrunt_linux_arm64
RUN chmod u+x /usr/local/bin/terragrunt

# Set Git configuration for GitHub URL substitution
RUN git config --global url."ssh://git@github.com/".insteadOf "https://github.com/"

RUN mkdir -p /root/.ssh && \
    echo "Host github.com\n\
    HostName github.com\n\
    IdentityFile ~/.ssh/id_ed25519_nepgpe\n" > /root/.ssh/config && \
    chmod 600 /root/.ssh/config

# Run ssh-keyscan to fetch and add the SSH public keys of the remote hosts
RUN mkdir -p /root/.ssh && \
    ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts && \
    chmod 600 /root/.ssh/known_hosts
