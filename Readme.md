Build 

```sh
docker build --tag jose-oc/ansible:alpine-3.19 -f Dockerfile .
```

## Usage

```sh
cd /some/ansible-project

docker run -it --rm \
-w /work \
-v `pwd`:/work \
-v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro \
--mount type=bind,source=$HOME/.ansible/vault_pass,target=/root/.ansible/vault_pass,readonly \
--entrypoint=/bin/sh \
jose-oc/ansible:alpine-3.19
```

### Alias

We can create an alias over the docker run command:

```shell
alias ansible-run='docker run --rm -it -w /work -v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro -v $HOME/code/NEP/TFC/DevOps/tfc-ansible-playbooks:/work jose-oc/ansible:alpine-3.19' 

alias ansible-playbook='docker run --rm -it -w /work -v $HOME/.ssh/ansible_id_rsa:/root/.ssh/ansible_id_rsa:ro -v $HOME/.ansible/vault_pass:/root/.ansible/vault_pass:ro -v $HOME/code/NEP/TFC/DevOps/tfc-ansible-playbooks:/work jose-oc/ansible:alpine-3.19 ansible-playbook'
```

Example of running this:

```shell
ansible-playbook -i inventories/tst/NLTST/hosts.yml T2_20_setup_logging_stack.yml --check
```
