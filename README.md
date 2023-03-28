# init-my-wsl

## when you forgot your password

in CMD, change your default user to root (debian or ubuntu) : 

```
debian config --default-user root
```

log into the wsl, you will be root

change your user password, for me it will be : 

```
passwd qproust
```

change back your default user : 


```
debian config --default-user qproust
```

relog into your wsl, your password will be ok.
