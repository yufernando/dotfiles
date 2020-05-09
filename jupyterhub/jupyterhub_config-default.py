c.JupyterHub.bind_url = 'http://:8000/jupyter'
c.JupyterHub.cookie_secret_file = '/srv/jupyterhub/jupyterhub_cookie_secret'
c.ConfigurableHTTPProxy.auth_token = '/srv/jupyterhub/proxy_auth_token'
c.ConfigurableHTTPProxy.command = '/home/fer/miniconda3/bin/configurable-http-proxy'
c.Spawner.default_url = '/lab' 
c.Authenticator.admin_users = {'fer'}
