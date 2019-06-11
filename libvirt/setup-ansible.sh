#!/bin/bash

vagrant ssh-config > /tmp/ssh-config

HOST=$(grep Host /tmp/ssh-config | head -n 1 | awk -F'[ ]+' '{ print $2}')
ADDR=$(grep HostName /tmp/ssh-config | head -n 1 | awk -F'[ ]+' '{ print $3}')
PORT=$(grep Port /tmp/ssh-config | head -n 1 | awk -F'[ ]+' '{ print $3}')
USER=$(grep User /tmp/ssh-config | head -n 1 | awk -F'[ ]+' '{ print $3}')
PRIVATE_KEY=$(grep IdentityFile /tmp/ssh-config | head -n 1 | awk -F'[ ]+' '{ print $3}')

cat <<EOF >ansible.cfg
[defaults]
inventory = hosts
remote_user = ${USER}
private_key_file = ${PRIVATE_KEY}
host_key_checking = False
EOF

cat <<EOF > hosts
${HOST} ansible_ssh_host=${ADDR} ansible_ssh_port=${PORT}
[local]
${HOST}
EOF

ansible all -m command -a "echo Hello Work on ${HOST}"

