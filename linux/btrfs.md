# BTRFS 

## Useful links
https://christitus.com/btrfs-guide/


## Basic commands


```
cat /etc/fstab
```


Disk free
```
sudo btrfs fi show
```

Disk usage
```
sudo btrfs fi du /
```

Scrub SubVolume, recommended running every week
```
sudo btrfs scrub start /
```

Balance Subvolume for Performance
```
sudo btrfs balance start -musage=50 -dusage=50 /
```

Stop running balance
```
sudo btrfs balance cancel /
```

List Subvolumes based on mountpoint
```
sudo btrfs subv list /home
```

Mount Subvolume
```
sudo mount -o subvolid=267 /dev/sda1 /media/games
```
or add to `/etc/fstab`
```
UUID=IDGOESHERE /media/games rw,exec,subvolid=267 0 0
```
