## Run

```shell script
ansible-playbook -i hosts --ask-vault-pass --ask-become-pass deploy.yml
```

## Vault

Place encrypted files in `vars/main.yml` files. Encrypt the values with the following command.

```shell script
ansible-vault encrypt_string 'value_to_encrypt' --name 'variable_name'
```

## Borg backups

In order to perform backups you need to add the SSH private key required to log into egidiocaprino.com to the root user.

## To-do
1. Remove SSH root access and align this Ansible setup.
