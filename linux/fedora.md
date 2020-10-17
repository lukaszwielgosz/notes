# Fedora

## DNF

```
sudo dnf config-manager --setopt=fastestmirror=True --save
```

## Fix expired SSL certificate
https://molo76.github.io/2017/07/04/dnf-update-behind-ssl-inspection-proxy.html
```
sudo update-ca-trust
```