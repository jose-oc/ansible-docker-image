FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get --quiet update && \
    apt-get --quiet --yes upgrade && \
    apt-get --quiet --yes install \
		curl \
		openssh-client \
		git \
		python3 \
		python3-pip \
		python-is-python3 \
 		sshpass

# Install Ansible
RUN apt-get --quiet update && \
    apt-get --quiet --yes upgrade && \
    apt-get --quiet --yes install \
		software-properties-common
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt-get --quiet --yes install ansible
#RUN apt-get clean all

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
RUN echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
RUN apt-get --quiet update && \
    apt-get --quiet --yes install kubectl
RUN apt-get clean all

# install python dependencies that I need for ansible
RUN pip install --upgrade pip kubernetes kubernetes-validate influxdb botocore boto3

# install galaxy collections
RUN ansible-galaxy collection install kubernetes.core community.mysql community.grafana
