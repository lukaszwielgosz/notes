# Wireguard setup and stuff
https://www.cyberciti.biz/faq/centos-8-set-up-wireguard-vpn-server/

https://dev.to/ivanmj16/how-to-install-and-configure-you-own-vpn-server-in-gcp-with-wireguard-2af0

https://www.jordanwhited.com/posts/wireguard-endpoint-discovery-nat-traversal/

https://wireguard.how/server/google-cloud-platform/


https://sreejithag.medium.com/set-up-wireguard-vpn-with-google-cloud-57bb3267a6ef

## Google cloud setup
Default udp listen port `51820`
 


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

## Server forwarding

enable ipv4 forwarding
```
vim /etc/sysctl.conf
sysctl --system
```
uncomment line `net.ipv4.ip_forward = 1`

```
sudo apt install linux-headers-$(uname -r)
```

reload config file
```
sudo su -c "wg addconf wgserver <(wg-quick strip wgserver)"
sudo wg-quick down wg0 && sudo wg-quick up wg0
```

check wireguard status
```
sudo wg show wgserver
```


# Fedora client
```
sudo dnf install wireguard-tools
sudo su -
cd /etc/wireguard
wg genkey | tee privatekey | wg pubkey > publickey
sudo cat privatekey

qrencode -t ansiutf8 < wg0.conf
```

```
vim wg0.conf
```

wg genkey | tee privatekey | wg pubkey > publickey