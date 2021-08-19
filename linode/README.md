# Linode Utilities

To setup a new server, use the Make recipes:

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
