# Portainer

[Portainer](https://www.portainer.io/) is a web-based continer management solution. To deploy the `portainer` container, copy the `portainer` folder of this repository, including all its contents to the server, such that it available as `/root/portainer`. To do this, use [WinSCP](https://en.wikipedia.org/wiki/WinSCP) on Windows, or a local Linux command (after navigating to the root directory of the files of this repository) and issue the following command:
```shell
scp -pr portainer etw:
```

On the server, rename `/root/portainer/.env.example` to `/root/portainer/.env`set the proper IPv4 addres(ses) in `/root/portainer/.env`. 

On the server, install portainer
```shell
cd /root/portainer
docker-compose up -d
```
