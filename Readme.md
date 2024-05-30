# Ansible with Ubuntu

This is a docker image to run ansible.

There are two flavors, one based on ubuntu and another one based on alpine.

## Ubuntu based

### Build

Build the docker image with a command like:

```sh
docker build --tag joseoc/ansible-ubuntu:latest -f Dockerfile .
```

### Usage

You can navigate to the directory where you have your ansible project and there run the docker command to create a new container and get into it to start running ansible. 

I assume you have a `vault_pass` file with your ansible vault password. 
I'm also sharing my keys with the container, I call it `ansible_id_rsa`.

```sh
cd /some/ansible-project

docker run -it --rm \
-w /work \
-v `pwd`:/work \
--mount type=bind,source=$HOME/.ansible/vault_pass,target=/root/.ansible/vault_pass,readonly \
-v $HOME/.config/gcloud:/root/.config/gcloud:ro \
-v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro \
-v $HOME/.ssh/ansible_id_rsa.pub:/root/.ssh/ansible_id_rsa.pub:ro \
-v $HOME/.ssh/id_ed25519_nepgpe:/root/.ssh/id_ed25519_nepgpe:ro \
-v $HOME/.ssh/id_ed25519_nepgpe.pub:/root/.ssh/id_ed25519_nepgpe.pub:ro \
joseoc/ansible-ubuntu:latest
```

#### Single command use

You can also run ansible commands, such as ansible-playbook or ansible-vault directly on your terminal without getting into the container. 
The advantadge of this is that you'll have the commands you run on your history. 

In this case we remove the container after using it so the disadvantage is that you can't rely on the effect of a previous command. 
For instance, you can't run `ansible-playbook -i inventory.yml install_python_dependencies_playbook.yml` to install some python dependencies and after that run `ansible-playbook -i inventory.yml another_playbook.yml` which uses those python dependencies. 

If you opt for this way, you can create some aliases on your shell:

```sh
alias ansible-run='docker run --rm -it -w /work -v `pwd`:/work -v $HOME/.config/gcloud:/root/.config/gcloud:ro -v $HOME/.ssh/id_ed25519_nepgpe.pub:/root/.ssh/id_ed25519_nepgpe.pub:ro -v $HOME/.ssh/id_ed25519_nepgpe:/root/.ssh/id_ed25519_nepgpe:ro -v $HOME/.ssh/ansible_id_rsa.pub:/root/.ssh/ansible_id_rsa.pub:ro -v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro -v $HOME/.kube:/root/.kube:ro joseoc/ansible-ubuntu:latest'  

alias ansible-playbook='docker run --rm -it -w /work -v `pwd`:/work -v $HOME/.ssh/ansible_id_rsa.pub:/root/.ssh/ansible_id_rsa.pub:ro -v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro joseoc/ansible-ubuntu:latest ansible-playbook'

alias ansible-vault='docker run --rm -it -w /work -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro -e ANSIBLE_VAULT_PASSWORD_FILE=/root/.ansible/vault_pass joseoc/ansible-ubuntu:latest ansible-vault'
```

Example of running this:

```shell
ansible-playbook -i inventories/datacenter1/hosts.yml playbook_a.yml
ansible-vault encrypt_string ilAnptTY6T --name vble_name
ansible-run
```




## Alpine based

### Build

Build the docker image with a command like:

```sh
docker build --tag joseoc/ansible:alpine-3.19 -f Dockerfile.alpine .
```

### Usage

You can navigate to the directory where you have your ansible project and there run the docker command to create a new container and get into it to start running ansible. 

I assume you have a `vault_pass` file with your ansible vault password. 
I'm also sharing my keys with the container, I call it `ansible_id_rsa`.

```sh
cd /some/ansible-project

docker run -it --rm \
-w /work \
-v `pwd`:/work \
-v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro \
--mount type=bind,source=$HOME/.ansible/vault_pass,target=/root/.ansible/vault_pass,readonly \
--entrypoint=/bin/sh \
joseoc/ansible:alpine-3.19
```

#### Single command use

You can also run ansible commands, such as ansible-playbook or ansible-vault directly on your terminal without getting into the container. 
The advantadge of this is that you'll have the commands you run on your history. 

In this case we remove the container after using it so the disadvantage is that you can't rely on the effect of a previous command. 
For instance, you can't run `ansible-playbook -i inventory.yml install_python_dependencies_playbook.yml` to install some python dependencies and after that run `ansible-playbook -i inventory.yml another_playbook.yml` which uses those python dependencies. 

If you opt for this way, you can create some aliases on your shell:

```sh
alias ansible-run='docker run --rm -it -w /work -v `pwd`:/work -v $HOME/.ssh/ansible_id_rsa.pub:/root/.ssh/ansible_id_rsa.pub:ro -v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro joseoc/ansible:alpine-3.19' 

alias ansible-playbook='docker run --rm -it -w /work -v `pwd`:/work -v $HOME/.ssh/ansible_id_rsa.pub:/root/.ssh/ansible_id_rsa.pub:ro -v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro -v $HOME/.kube:/root/.kube:ro joseoc/ansible-ubuntu:latest ansible-playbook'

alias ansible-vault='docker run --rm -it -w /work -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro -e ANSIBLE_VAULT_PASSWORD_FILE=/root/.ansible/vault_pass joseoc/ansible:alpine-3.19 ansible-vault'
```

Example of running this:

```shell
ansible-playbook -i inventories/datacenter1/hosts.yml playbook_a.yml
ansible-vault encrypt_string ilAnptTY6T --name vble_name
ansible-run
```
