# SSH
Generate ssh key
```
ssh-keygen
```

Copy ssh public key to remote host
```
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host
```

Rregenerate key known_hosts
```
ssh-keygen -R HOSTNAME
```

## Install and enable ssh server ubuntu
```
sudo apt install ssh -y
sudo systemctl enable --now ssh
```