# API v2

The [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) is an open souce solution that serves the Twomes REST API to the Twomes WarmteWachter app and Twomes measurement devices based on Twomes firmware and that used a Twomes database based on MariaDB. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

> **Info**
> Click [here](https://github.com/energietransitie/twomes-backoffice-configuration/tree/36ebeff11f1cb7c0d57a48db7ac1254c6b9c2061#api) for environment variables for API v1.
>
> The compose path there is `api/v1/<env>/docker-compose.yml`.

## Compose path

The compose path for this stack is:

### Production
```
api/v2/prd/docker-compose.yml
```

### Test
```
api/v2/tst/docker-compose.yml
```

## Environment variables

### `TWOMES_DSN`

This environment variable is used to set the DSN (data source name) to connect to.

Example values: `readonly_researcher:correcthorsebatterystaple@tcp(mariadb_dev:3306)/twomes`

> The composition of the connection string is as follows: `<db_user>:<db_password>@<protocol>(<db_host>:<db_port>)/<db_name>`.
>
> It is recommended to use a user and password without special characters to avoid parsing errors.

### `TWOMES_BASE_URL`

This environment variable is used to set the base URL used by the Swagger UI docs.

Example values: `https://api.energietransitiewindesheim.nl/v2` or `https://api.tst.energietransitiewindesheim.nl/v2`
