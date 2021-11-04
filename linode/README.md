# Linode Utilities

This repository contains automated scripts for creating Linodes from the command line. For this to work you need to install `linode-cli` in a virtual environment with `pip install linode-cli`.

1. Create a Linode. Put the following configuration variables in an .env file:
```
USERNAME=
STACKSCRIPT_ID=
REGION=
IMAGE=
PLAN=
IGNOREIP=
SSHKEY=
```
The last two are optional. Then run make:
```
make deploy
```
You will be asked for a hostname and a password.

2. Check status:
```
make list
```

3. Show logs:
```
make logs
```

4. SSH into a Linode:
```
make ssh
```

5. Delete Linode
```
linode-cli linodes delete [LINODE-ID]
```


## Manual creation

These are recipes for a less automated creation of a Linode.

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
