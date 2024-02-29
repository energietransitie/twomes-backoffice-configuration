# Duplicati

[Duplicati](https://www.duplicati.com/) is an online backup sotware solution.  

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

## Compose path

The compose path for this stack is:

### Production
```
duplicati/prd/docker-compose.yml
```

### Test
```
duplicati/tst/docker-compose.yml
```

## Environment variables

### `DB_PASSWORD`

This environment variable is used to set the database password.

Example values: `78sb6g654b56sdv7s89dv` or `as78sdv78sfdv67sdv5dc8sdv09sv`

### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).