# Traefik

[Traefik proxy](https://traefik.io/traefik/) is a reverse proxy and load balancer. All http(s) access to the server goes through the Traefik proxy. This
proxy takes care of virtual host for multiple subdomains of energietransitiewindesheim.nl, and takes care of Let's Encrypt certificate (re-)generation.

To deploy the `traefik` container, clone this repository on the server in the home directory of the root user, such that the repository's contents are available at `/root/needforheat-server-configuration`. Use the following command in the home directory of the root user (`/root`):
```shell
cd
git clone https://github.com/energietransitie/needforheat-server-configuration.git
```

> In the rest of the commands concerning traefik, you should substitute `<env>` with your chosen environment (`prd` or `tst`).

On the server, set the proper credentials and IPv4 address(es) in `/root/needforheat-server-configuration/traefik/<env>/traefik_dynamic.toml` to access the traefik dashboard. 
On the server, set the proper credentials for your email in `/root/needforheat-server-configuration/traefik/<env>/traefik.toml`. 

On the server, do the following.
```shell
docker network create web
cd /root/needforheat-server-configuration/traefik/<env>
touch acme.json
chmod 600 acme.json
```

Start the Traefik proxy
```shell
cd /root/needforheat-server-configuration/traefik/<env>
docker-compose -p traefik-<env> up -d
```
