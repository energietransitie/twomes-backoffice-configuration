# Portainer

[Portainer](https://www.portainer.io/) is a web-based continer management solution. 

To deploy the `portainer` container, clone this repository on the server in the home directory of the root user, such that the repository's contents are available at `/root/needforheat-server-configuration`. Use the following command in the home directory of the root user (`/root`):
```shell
cd
git clone https://github.com/energietransitie/needforheat-server-configuration.git
```

> In the command below, you should substitute `<env>` with your chosen environment (`prd` or `tst`).

On the server, start portainer
```shell
cd /root/portainer/<env>
docker-compose -p portainer-<env> up -d
```
