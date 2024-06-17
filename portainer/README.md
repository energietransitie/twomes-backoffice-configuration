# Portainer

[Portainer](https://www.portainer.io/) is a web-based continer management solution. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) for general instructions on deploying stacks using Portainer.

## Compose path

The compose path for this stack is:
```
portainer/docker-compose.yml
```

## Environment variables

### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

### `SERVER_TYPE`

For a test server, we recomment to use `tst` and for a production server, `prd`. 

### `DOMAIN`

Specify the domain that will be used; for a test server we recomend to prefix this with `tst.`, so:

* for a test  server, set e.g. `DOMAIN=tst.energietransitiewindesheim.nl`
* for a production server, set e.g. `DOMAIN=energietransitiewindesheim.nl`

The fully URLs to access portainer will become:

* test server: `https://portainer.tst.energietransitiewindesheim.nl`
* production server: `https://portainer.energietransitiewindesheim.nl`

