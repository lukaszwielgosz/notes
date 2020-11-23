# Screen

```
screen -d -m command
screen -d -m ./dcom -H 127.0.0.1 -p 3434
```

List screens

`screen -ls`
```
There are screens on:
	49157..localhost	(Attached)
	48987.pts-1.localhost	(Detached)
2 Sockets in /run/screen/S-quadro5000.

```

`screen -r 48987`

`ctrl + a + d` detach
