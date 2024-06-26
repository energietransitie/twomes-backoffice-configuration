# API v3

The [NeedForHeat Server API](https://github.com/energietransitie/needforheat-server-api) is an open souce solution that serves the NeedForHeat REST API to the [NeedForHeat GearUp App](https://github.com/energietransitie/needforheat-gearup-app) and NeedForHeat measurement devices based on NeedForHeat firmware and that used a NeedForHeat database based on MariaDB. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

> **Info**
> Click [here](https://github.com/energietransitie/needforheat-server-configuration/tree/36ebeff11f1cb7c0d57a48db7ac1254c6b9c2061#api) for environment variables for API v3.
>
> The compose path there is `api/v3/<env>/docker-compose.yml`.

## Compose path

The compose path for this stack is:

### Production
```
api/v3/prd/docker-compose.yml
```

### Test
```
api/v3/tst/docker-compose.yml
```

## Environment variables

### `NFH_DSN`

This environment variable is used to set the DSN (data source name) to connect to.

Example values: `readonly_researcher:correcthorsebatterystaple@tcp(mariadb_dev:3306)/needforheat`

> The composition of the connection string is as follows: `<db_user>:<db_password>@<protocol>(<db_host>:<db_port>)/<db_name>`.
>
> It is recommended to use a user and password without special characters to avoid parsing errors.

### `NFH_BASE_URL`

This environment variable is used to set the base URL used by the Swagger UI docs.

Example values: `https://api.example.com/v2` or `https://api.tst.example.com/v2`
