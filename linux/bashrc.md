# .bashrc mod

modify '~/.bashrc'

to apply changes
```
source ~/.bashrc
```

## Change how prompt looks
Value	Color
0	Black
1	Red
2	Green
3	Yellow
4	Blue
5	Magenta
6	Cyan
7	White
8	Not used
9	Reset to default color
```
export PS1="\[$(tput setaf 3)$(tput bold)\][\u@\h \W]$ \[$(tput sgr0)\]"
```
