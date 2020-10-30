# How to share usb devices via ip

Install usbip on both machines
fedora:
```
sudo dnf install usbip
```

debian/ubuntu:
```
sudo apt install usbip
```

## Server side

Load 2 kernel modules:
```
sudo modprobe usbip-core
sudo modprobe usbip-host
```

Start usbip server as daemon:
```
sudo usbipd -D
```

Check what USB devices we can share
```
sudo usbip list -l
```

Share device:
```
sudo usbip bind -b 1-1.3
```

Stop sharing device
```
sudo usbip unbind -b 1-1.3
```

## Client side

Load kernel modules
```
sudo modprobe usbip-core
sudo modprobe vhci-hcd
```

List devices remote server shares
```
sudo usbip list -r 192.168.0.196
```

Attach usb device
```
sudo usbip attach -r 192.168.0.196 -b 1-1.3
```

Check if device works:
```
lsusb
```

### Detaching:
Devices that are attached to a client via USB/IP are blocked for the rest of the network, so at some point, you will want to detach them and let others use them.

List:
```
sudo usbip port
```

Detach:
```
sudo usbip detach -p 00
```