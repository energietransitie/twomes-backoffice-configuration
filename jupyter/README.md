# JupyterLab

[JupyterLab](https://jupyter.org/) is a web-based interactive development environment for notebooks, code, and data. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

> [!IMPORTANT]
> The name you set as the *stack* name, will be used as the subdomain of the domain you set with the environment variable `DOMAIN`.
 
## Compose path

The compose path for this stack is:
```
jupyter/docker-compose.yml
```

## Environment variables

### `TWOMES_DB_URL`

This environment variable is used to set the connection string which is used to connect to the NeedForHeat database.

Example values: `readonly_researcher:correcthorsebatterystaple@mariadb_dev:3306/twomes_v2`

> The composition of the connection string is as follows: `<db_user>:<db_password>@<db_host>:<db_port>/<db_name>`.
>
> It is recommended to use a user and password without special characters to avoid parsing errors.

### `IP_WHITELIST`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

### `DOMAIN`

Specify the domain that will be used; for a test server we recommend to prefix this with `tst.`, so:

* for a test  server, set e.g. `DOMAIN=tst.example.com`
* for a production server, set e.g. `DOMAIN=example.com`

So, if you  specified  `analysis-one` as the stack name, the fully qualified domains will become:

* test server: `https://analysis-one.tst.example.com`
* production server: `https://analysis-one.example.com`


## First time log in

After the container is fully started, you can use [Portainer](../portainer/README.md) to find the JupyterLab token in the containers logs. Search for `token` if don't see it immediately.

1. Copy the token and navigate to the URL of the JupyterLab instance you just created.

    > If this does not work immediately, wait a minute and try again (Traefik may not have processed the Let's Encrypt certificate yet).

2. Setup a password at the bottom of the page, by pasting the token and choosing a password. Then click on 'Log in and set new password'.

