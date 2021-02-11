# Fedora

## sudo
```
usermod -aG wheel lukasz
```


Install AppEditor
```
sudo dnf install appeditor
```

## DNF

```
sudo dnf config-manager --setopt=fastestmirror=True --save
```

## Fix expired SSL certificate
https://molo76.github.io/2017/07/04/dnf-update-behind-ssl-inspection-proxy.html
```
sudo update-ca-trust
```


## Running Eagle
When trying to run Eagle on fedora, following error is shown:

Could not initialize GLX
Aborted (core dumped)

try to run it like this:
```
QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_SCALE_FACTOR=0.5 QT_XCB_GL_INTEGRATION=xcb_egl ./eagle
```

