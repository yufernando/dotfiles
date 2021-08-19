# Linode Utilities

1. Create a Linode:
```
make deploy
```
You will be asked for a hostname and a password

2. SSH into a Linode:
```
make ssh
```

3. Check status:
```
make status
```

## Manual creation

These are recipes for a less automated creation of a Linode

1. Create a Linode
```
make create label=myserver
```

2. Get the IP Adress with `linode-cli linodes list` and copy SSH keys:
```
make keys ip=ip-address
```

3. Setup and configure:
```
make setup ip=ip host=host user=user pass=pass ignoreip=ignoreip
```
