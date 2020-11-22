# .bashrc mod

modify '~/.bashrc'

to apply changes
```
source ~/.bashrc
```

## Change how prompt looks

```
export PS1="\[$(tput setaf 3)$(tput bold)\][\u@\h \W]$ \[$(tput sgr0)\]"
```
