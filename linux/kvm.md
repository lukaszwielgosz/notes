# KVM

## Setup on fedora
### Ensure your CPU has Intel VT or AMD-V Virtualization extensions

The first step is to confirm that your CPU has either Intel VT or AMD-V Virtualization extensions. In some systems, this is disabled on BIOS and you may need to enable it.

```
cat /proc/cpuinfo | egrep "vmx|svm"
```

### Install KVM / QEMU and tools
```
sudo dnf -y install bridge-utils libvirt virt-install qemu-kvm
sudo dnf -y install virt-top libguestfs-tools virt-manager
```

verify that kernel modules are loaded
```
$ lsmod | grep kvm
kvm_intel             319488  0
kvm                   823296  1 kvm_intel
irqbypass              16384  1 kvm
```

### Start and enable KVM daemon
```
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
```