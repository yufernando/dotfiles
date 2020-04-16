# Jupyterhub
c.JupyterHub.bind_url = 'http://:8000/jupyter'

# Uncomment 3 lines hen serving directly (without nginx):
# sudo /home/fer/miniconda3/bin/jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
# c.JupyterHub.bind_url = 'https://aretian.dev/jupyter'
c.JupyterHub.bind_url = 'https://aretian.dev'
c.JupyterHub.ssl_cert = '/etc/letsencrypt/live/aretian.dev/fullchain.pem'
c.JupyterHub.ssl_key = '/etc/letsencrypt/live/aretian.dev/privkey.pem'

# General Settings
# c.LocalAuthenticator.create_system_users = True
c.Authenticator.admin_users = {'fer'}

# HTTP Proxy
c.ConfigurableHTTPProxy.auth_token = '/srv/jupyterhub/proxy_auth_token'
c.ConfigurableHTTPProxy.command = '/home/fer/miniconda3/bin/configurable-http-proxy'
c.JupyterHub.cookie_secret_file = '/srv/jupyterhub/jupyterhub_cookie_secret'

# Spawner
c.Spawner.default_url = '/lab' 
# c.Spawner.cmd = ['/home/fer/miniconda3/bin/jupyterhub-singleuser']

# Docker
from dockerspawner import DockerSpawner
c.JupyterHub.spawner_class = DockerSpawner
c.DockerSpawner.remove_containers = True
# c.DockerSpawner.image = 'singleuser'
# c.DockerSpawner.image = 'jupyter/scipy-notebook'
c.DockerSpawner.image = 'jupyterhub/singleuser'

# The docker instances need access to the Hub, so the default loopback port doesn't work:

# Carol Willig fix
# from jupyter_client.localinterfaces import public_ips
# c.JupyterHub.hub_ip = public_ips()[0] #172.104.208.35
# c.JupyterHub.port=8000
# c.JupyterHub.hub_port = 1453
# c.JupyterHub.port=443

# Minrk fix
import netifaces
docker0 = netifaces.ifaddresses('docker0')
docker0_ipv4 = docker0[netifaces.AF_INET][0]
c.JupyterHub.hub_ip = docker0_ipv4['addr'] #172.17.0.1

# Eaton lab fix
# c.JupyterHub.hub_ip = c.JupyterHub.ip
