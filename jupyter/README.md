# JupyterLab

[JupyterLab](https://jupyter.org/) is a web-based interactive development environment for notebooks, code, and data. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

## Compose path

The compose path for this stack is:

```
jupyter/docker-compose.yml
```

## Environment variables

### `COMPOSE_PROJECT_NAME`

The environment variable `COMPOSE_PROJECT_NAME` is used to set the domain name used to connect to the JupyterLab instance. It is usually the same as the container name.

Example values: `jupyter`, `notebook` or `analysis`

### `TWOMES_DB_URL`

This environment variable is used to set the connection string which is used to connect to the Twomes database.

Example values: `readonly_researcher:correcthorsebatterystaple@mariadb_dev:3306/twomes`

> The composition of the connection string is as follows: `<db_user>:<db_password>@<db_host>:<db_port>/<db_name>`.
>
> It is recommended to use a user and password without special characters to avoid parsing errors.

### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

## Additional steps

After the container is fully started, you can use [Portainer](#portainer) to find the JupyterLab token in the logs. Search for `token` if don't see it immediately. To access the JupyterLab container, browse to this URL: `http://<subdomain>.energietransitiewindesheim.nl/lab?token=<jupyter_token>`. Make sure the name corresponds to an existing subdomain (at Windesheim, we use `jupyter`, `notebook` and `analysis` as subdomains for 3 JupyterLab instances).

> If this does not work immediately, wait a minute and try again (Traefik may not have processed the let's Encrypt certificate yet).

- Via the JupyterLab web interface:
    - Use the launcher (always avalable via the `+` tab), launch a terminal window and the command: 
    ```shell
    pip install jupyterlab-git
    ```
  - Enable Show hidden files via Settings / Advanced Settings editor / File Browser / Show hidden files.
  - Enable the Extension manager (puzzle icon in left pane).
  - If you wish to have a stable token after each forced restart, you can use [Portainer](#portainer), go to the container and via `Duplicate/Edit` > `Advanced container settings` > `Env` > `Add environment variable`, with name `JUPYTER_TOKEN` and a secret token with a proper length (e.g., 48 characters).
- Restart container via Portainer and access it again via the proper URL.
- Now, you can clone repositories, e.g. [twomes-twutility-inverse-grey-box-analysis](https://github.com/energietransitie/twomes-twutility-inverse-grey-box-analysis) via https://github.com/energietransitie/twomes-twutility-inverse-grey-box-analysis.git.
