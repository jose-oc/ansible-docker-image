FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get --quiet update && \
    apt-get --quiet --yes upgrade && \
    apt-get --quiet --yes install \
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
RUN apt-get clean all

# install python dependencies that I need for ansible
RUN pip install --upgrade pip kubernetes kubernetes-validate
