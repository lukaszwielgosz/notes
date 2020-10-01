# Wireguard setup and stuff
https://www.cyberciti.biz/faq/centos-8-set-up-wireguard-vpn-server/

https://dev.to/ivanmj16/how-to-install-and-configure-you-own-vpn-server-in-gcp-with-wireguard-2af0

https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/

## Install on ubuntu
```
sudo apt install wireguard-tools -y
```

## Generate keys

```
sudo -i
cd /etc/wireguard
```
```
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
```

## Configure Client
```
nano /etc/wireguard/wg0.conf
```

sample file:
```
[Interface]
PrivateKey = client private key here
Address = 10.50.0.100/32
 
[Peer]
PublicKey = server public key here
#AllowedIPs = 10.50.0.0/24
AllowedIPs = 0.0.0.0/0
Endpoint = IP:port
PersistentKeepalive = 15
```

enable, start, check status
```
sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0
sudo systemctl status wg-quick@wg0
```

## Server

reload config file
```
sudo su -c "wg addconf wgserver <(wg-quick strip wgserver)"
```

check wireguard status
```
sudo wg show wgserver
```