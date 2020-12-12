c.JupyterHub.bind_url = 'http://:8000'
# c.JupyterHub.bind_url = 'http://:8000/jupyter' # Previously served from /jupyter endpoint
c.JupyterHub.cookie_secret_file = '/srv/jupyterhub/jupyterhub_cookie_secret'
c.ConfigurableHTTPProxy.auth_token = '/srv/jupyterhub/proxy_auth_token'
c.ConfigurableHTTPProxy.command = '/home/fer/miniconda3/bin/configurable-http-proxy'
c.Spawner.default_url = '/lab' 
c.Authenticator.admin_users = {'fer'}
# Add user's conda environments to path: https://github.com/jupyterhub/jupyterhub/issues/2136#issuecomment-420642694
# c.Spawner.cmd="/srv/jupyterhub/launch-script.sh"

# Edit Login page: https://github.com/jupyterhub/jupyterhub/issues/1385#issuecomment-466178702
# Comment following line to disable custom login page
c.JupyterHub.template_paths=['/srv/jupyterhub']

# Jupyter extension
# import os
# os.environ['JUPYTER_CONFIG_DIR'] = '/usr/local/etc/jupyter/nbconfig'
# c.Spawner.env_keep.append('JUPYTER_CONFIG_DIR')
