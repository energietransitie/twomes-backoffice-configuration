# Traefik

[Traefik proxy](https://traefik.io/traefik/) serves as a reverse proxy and load balancer, handling HTTP(S) traffic for multiple subdomains under energietransitiewindesheim.nl and managing Let's Encrypt certificates.

Follow the steps in the [deploying section of the main README](../README.md#deploying-stacks-with-portainer) for general instructions on deploying stacks using Portainer.

## Compose path

The compose path for deploying Traefik via Portainer is:

```plaintext
traefik/docker-compose.yml
```

## Environment variables

Ensure the following environment variables are configured when deploying Traefik:

### `EMAIL`

Set the email address for Let's Encrypt certificate notifications.

Example value: `your_email@example.com`

### `IP_Whitelist`

Set the allowed IPs (or ranges of allowed IPs using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

### `SERVER_TYPE`

Use `tst` for a test server and `prd` for a production server.

### `DOMAIN`

Specify the domain to be used. For a test server, prefix with `tst.`.

* Test server example: `DOMAIN=tst.energietransitiewindesheim.nl`
* Production server example: `DOMAIN=energietransitiewindesheim.nl`

If `traefik` is specified as the stack name, the fully qualified domains will become:

* Test server: `https://traefik.tst.energietransitiewindesheim.nl`
* Production server: `https://traefik.energietransitiewindesheim.nl`

### `BASIC_AUTH_USERS`

Define basic authentication users for accessing Traefik's dashboard and API. Each user should be in the format `username:hashed_password`, where `hashed_password` is the result of using `htpasswd` or a similar tool to hash the password.

Example value:
 ```bash
admin:$apr1$y3LBsSjB$3N1Q3Vq./YByzZDfZm5Op0,user:$apr1$wG6iM7Ju$RjTtXymC2g3eGnUf7dQ5e
 ```

> To generate a hashed password, you can use the `htpasswd` tool on Linux or other available tools online.

Ensure that the hashed passwords are securely managed and not exposed in plain text.

## Summary

Deploy Traefik via Portainer to manage HTTPS traffic and certificates for your domains seamlessly. Ensure all necessary environment variables are set for proper operation.

