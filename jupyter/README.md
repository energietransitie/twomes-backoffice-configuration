# JupyterLab

[JupyterLab](https://jupyter.org/) is a web-based interactive development environment for notebooks, code, and data. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

> [!IMPORTANT]
> The name you set as the *stack* name, will be used as the subdomain.
> 
> Example with `analysis-one` as the stack name:
>   - test: `https://analysis-one.tst.energietransitiewindesheim.nl`
>   - production: `https://analysis-one.energietransitiewindesheim.nl`

## Compose path

The compose path for this stack is:

### Production
```
jupyter/prd/docker-compose.yml
```

### Test
```
jupyter/tst/docker-compose.yml
```

## Environment variables

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

After the container is fully started, you can use [Portainer](../portainer/README.md) to find the JupyterLab token in the logs. Search for `token` if don't see it immediately.

1. Copy the token and navigate to the URL of the created jupyterlab instance.
    > See important note at the top of this page for an example of what your URL will be.

    > If this does not work immediately, wait a minute and try again (Traefik may not have processed the let's Encrypt certificate yet).

2. Setup a password at the bottom of the page, by pasting the token and choosing a password. Then click on 'Log in and set new password'.

3. Enable the Extension manager (puzzle icon in the sidebar on the left).

4. Now you can clone repositories using the git plugin on the sidebar, e.g. [twomes-twutility-inverse-grey-box-analysis](https://github.com/energietransitie/twomes-inverse-grey-box-analysis) via https://github.com/energietransitie/twomes-inverse-grey-box-analysis.git
