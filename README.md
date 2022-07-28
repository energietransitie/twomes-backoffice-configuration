# Twomes Backoffice Server Configuration

This repository contains configuration scripts and instructions for configuring a Twomes Backoffice server, comprising of multiple Docker containers hosted on a Linux server, based on the following technologies: [Traefik proxy](https://traefik.io/traefik/), [Portainer](https://www.portainer.io/), [MariaDB](https://mariadb.org/), [CloudBeaver](https://cloudbeaver.io/), [Duplicati](https://www.duplicati.com/), [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) and [JupyterLab](https://jupyter.org/).

NB: Where you read `energietransitiewindesheim.nl` below, you should subsitute your own domain; where you read `etw` below, you should subsitute your own server abbreviation. 

## Table of contents
* [Prerequisites](#prerequisites)
* [Deploying](#deploying)
* [Features](#features)
* [Status](#status)
* [License](#license)
* [Credits](#credits)

## Prerequisites

### SSH setup

For easy ssh/scp access to the server, copy your ssh certificate to
the server. This requires the root password once; after that, your
ssh key will be used for authentication.

Open a Linux command window on your local system. On Windows, you can use e.g. [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) for this. 

Generate a public/private key pair (files `.ssh/etw.pub` and `.ssh/etw`)
```shell
ssh-keygen -f ~/.ssh/etw
```

When asked for passphrase, leave that empty.

Now, upload your public key to the server.
```shell
ssh-copy-id -i ~/.ssh/etw root@energietransitiewindesheim.nl
```

Login with ssh, without using a password
```shell
ssh -i ~/.ssh/etw root@energietransitiewindesheim.nl
```

Append the following to your `.ssh/config`
```text
Host etw
User root
HostName energietransitiewindesheim.nl
IdentityFile ~/.ssh/etw
```

With this config in place, login to the server is simply
```shell
ssh etw
```

### Domain setup

We recommend using multiple hostnames for your domain (`energietransitiewindesheim.nl` in our example), each giving access to an API or web interface of a specific services hosted in a specific container.

For the Twomes backoffice production API:
- `api.energietransitiewindesheim.nl` : [api](#api)

For the Twomes backoffice test API:
- `api.tst.energietransitiewindesheim.nl` : [api](#api)

For system services:
- `proxy.energietransitiewindesheim.nl` : [traefik](#traefik)
- `docker.energietransitiewindesheim.nl` : [portainer](#portainer)
- `db..energietransitiewindesheim.nl` : [cloudbeaver](#cloudbeaver)
- `deploy.energietransitiewindesheim.nl` : deploy webhook
- `backup.energietransitiewindesheim.nl` : [duplicati](#backup)

For JupyterLab notebooks (we use 3 JupyterLab notebooks, each in its own container):
- `jupyter.energietransitiewindesheim.nl` : [jupyter](#jupyterlab)
- `notebook.energietransitiewindesheim.nl` : [notebook](#jupyterlab)
- `analysis.energietransitiewindesheim.nl` : [analysis](#jupyterlab)

## Deploying

### Traefik

[Traefik proxy](https://traefik.io/traefik/) is a reverse proxy and load balancer. All http(s) access to the server goes through the Traefik proxy. This
proxy takes care of virtual host for multiple subdomains of energietransitiewindesheim.nl, and takes care of Let's Encrypt certificate (re-)generation.

To deploy the `traefik` container, copy the `traefik` folder of this repository, including all its contents to the server, such that it available as `/root/traefik`. To do this, use [WinSCP](https://en.wikipedia.org/wiki/WinSCP) on Windows, or a local Linux command  (after navigating to the root directory of the files of this repository) and issue the following command: 
```shell
scp -pr traefik etw:
```

On the server, set the proper credentials and IPv4 addres(ses) in `/root/traefik/traefik_dynamic.toml`. 
On the server, set the proper credentials for your email in `/root/traefik/traefik.toml`. 

On the server, do the following.
```shell
docker network create web
cd traefik
touch acme.json
chmod 600 acme.json
```

Start the Traefik proxy
```shell
cd /root/traefik
docker-compose up -d
```

### Portainer

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

### MariaDB

[MariaDB](https://mariadb.org/) is an open source relational database. To deploy the `mariadb` containers (one for test and one for production), copy the `mariadb` directory to the server, in `/root`:
```shell
scp -pr mariadb etw:
```

On the server, rename `/root/mariadb/prd/.env.example` and `/root/mariadb/tst/.env.example` to `/root/mariadb/prd/.env` and `/root/mariadb/tst/.env` and replace `secret` by the proper root passwords of the MariaDB databases.

Then start the container
```shell
cd /root/mariadb/tst
docker-compose up -d
cd /root/mariadb/prd
docker-compose up -d
```

Accessing the database servers on their own hostname on the default port, for instance `db.energietransitiewindesheim.nl`, using a secure TLS connection, does not work. MariaDB does not support SNI, so there is no way to share the port.

To securely access the databases, you should configure an ssh user, e.g.  `dbtunnel`, with permissions to forward ports from local to 3306 (production) and 3307 (test). After setting up the ssh connection with port forwarding, the database is available on a local port, e.g. `localhost:3306`. 

The `dbtunnel` user works with a private key (distributed out-of-band).

Example usage, with private key in `~/.ssh/dbtunnel`, for access to the production database:
```shell
ssh -i ~/.ssh/dbtunnel dbtunnel@energietransitiewindesheim.nl -L 3306:localhost:3306 -N
```

### CloudBeaver

[CloudBeaver](https://cloudbeaver.io/) is a web-based database manager. To deploy the `cloudbeaver` container, copy the `cloudbeaver` folder of this repository, including all its contents to the server, such that it available as `/root/cloudbeaver`. To do this, use [WinSCP](https://en.wikipedia.org/wiki/WinSCP) on Windows, or a local Linux command (after navigating to the root directory of the files of this repository) and issue the following command:
```shell
scp -pr cloudbeaver etw:
```

On the server, rename `/root/cloudbeaver/.env.example` to `/root/cloudbeaver/.env`set the proper IPv4 addres(ses) in `/root/cloudbeaver/.env`. 

On the server, install cloudbeaver
```shell
cd /root/cloudbeaver
docker-compose up -d
```


### Backup

[Duplicati](https://www.duplicati.com/) is an online backup sotware solution. To deploy the `backup` container, copy the `duplicati` folder of this repository, including all its contents to the server, such that it available as `/root/duplicati`. To do this, use [WinSCP](https://en.wikipedia.org/wiki/WinSCP) on Windows, or a local Linux command (after navigating to the root directory of the files of this repository) and issue the following command: 
```shell
scp -pr duplicati etw:
```

On the server, rename `/root/duplicati/.env.example` to `/root/duplicati/.env` and replace `secret` by the actual root passwords of the MariaDB databases. Set also the proper IPv4 addres(ses) in `/root/duplicati/.env`. 

On the backup destination, create a directory for each environment (with the name `dev` and `prod`). For academic research in the Netherlands, [SURFdrive](https://www.surf.nl/surfdrive-bewaar-en-deel-je-bestanden-veilig-in-de-cloud?dst=n1460) or [Research Drive](https://wiki.surfnet.nl/display/RDRIVE/SURF+Research+Drive+wiki) might be a suitable backup destination in combination with the WebDAV protocol.

Log in as root on the Twomes backoffice server and start the container using the following command:
```shell
cd /root/duplicati
docker-compose up -- build -d
```


Use a web brower to navigate to [https://backup.energietransitiewindesheim.nl](https://backup.energietransitiewindesheim.nl), follow the wizard and use `Add backup` to add backup tasks using the option `Import from a file`. For convenience, we provided the files [backup_prod-duplicati-config.json](backup_prod-duplicati-config.json) and [backup_dev-duplicati-config.json](backup_dev-duplicati-config.json) as templates; add your own credentials and passphrases.
#### Restore

Click restore and the environment and then the version you want to restore.

Check the `db.dump` and hit continue and restore.

### API

The [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) is an open souce solution that serves the Twomes REST API to the Twomes WarmteWachter app and Twomes measurement devices based on Twomes firmware and that used a Twomes database based on MariaDB. To deploy the Twomes api containers, copy the `api` folder of this repository, including all its contents to the server, such that it available as `/root/api`. To do this, use [WinSCP](https://en.wikipedia.org/wiki/WinSCP) on Windows, or a local Linux command (after navigating to the root directory of the files of this repository) and issue the following command:
```shell
scp -pr api etw:
```

On the server, rename `/root/api/prd/.env.example` to `/root/api/prd/.env` and `/root/api/tst/.env.example` to `/root/api/tst/.env` and replace `secret` by the actual root passwords of the MariaDB databases.

Then start (or redeploy after image update)
```shell
docker pull ghcr.io/energietransitie/twomes_api:latest
cd /root/api/tst
docker-compose up -d
cd /root/api/prd
docker-compose up -d
```

### JupyterLab

[JupyterLab](https://jupyter.org/) is a web-based interactive development environment for notebooks, code, and data. To deploy a JupyterLab notebook to a container, add a docker container (using [portiner](#portainer)) with the following charcteristics (keep the defualt values for all other options default values), after setting all values below select `Deploy the container`
- Name:`jupyter`, `notebook` or `analysis` (preferably use a name that corresponds with a subdomain you have available for accessing the JupyterLab notebook web page) 
- Image / docker.io `jupyter/datascience-notebook:latest`
- Advanced container settings / Command & logging: tick `Interactive & TTY`
- Advanced container settings / Env / Load variables from .env file (.env file with proper values to access the MariaDB container and database you want)
- Advanced container settings / Network: add the `web` network
- Advanced container settings / Labels: add the following names and values, while replacing `<Name>`  with the name of the chosen subdomain:
  - name: `traefik.http.routers.<Name>.rule`; value: ``Host(`<Name>.energietransitiewindesheim.nl`)``
  - name: `traefik.http.routers.<Name>.tls`; value: `true`
  - name: `traefik.http.routers.<Name>.tls.certresolver`; value: `lets-encrypt`
  - name: `traefik.http.services.<Name>.loadbalancer.server.port`; value: `8888`
- After the container started fully, look at the logs and look for a line that includes `http://127.0.0.1:8888/lab?token=`, after which you fint the token. You can access the JupyterLab now on this URL: `http://<Name>.energietransitiewindesheim.nl/lab?token=<token>`. Replace  `<Name>`  with the name of the subdomain you have; in the URL you browse to, . If this does not work immediately, wait a minute and try again (Traefik may not have processed the let's Enctrypt certificate yet).
- Via the JupyterLab web interface
    - Use the launcher (always avalable via the `+` tab), launch a terminal window and the command: 
    ```shell
    pip install jupyterlab-git
    ```
  - Enable Show hidden filles via Settings / Advanced Settings editor / File Browser / Show hidden files
  - Enable the Extension manager (puzzle icon in left pane)
- Restart container via Portainer (this may cause the token to change)
- After the container started fully, look again at the logs and look for a line that includes `http://127.0.0.1:8888/lab?token=`, after which you fint the token. You can access the JupyterLab now on this URL: `http://<Name>.energietransitiewindesheim.nl/lab?token=<token>`. In the URL you browse to, replace  `<Name>`  with the name of the chosen subdomain you have and replace <token> with the token you found in this step.

## Features
List of features ready and TODOs for future development. Ready:

- [x] Implementing automated backup solution
- [x] Limiting access by IPv4 address
- [x] Ratelimiting on the API

To-do:
- [ ] Further implementation of Dependabot
- [ ] Create only docker-compose file for Traefik instead of .toml files
- [ ] Integrated deployment of the entire Twomes Backoffice stack

Optional:
- [ ] force use of SSH tunnel to `portainer` container
- [ ] force use of SSH tunnel to `cloudbeaver` container
- [ ] force use of SSH tunnel to `traefik` container

## Status
Project is: _in progress_

Current version is stable. Room for improvement.

## License

This software is available under the [Apache 2.0 license](./LICENSE), 
Copyright 2022 [Research group Energy Transition, Windesheim University of 
Applied Sciences](https://windesheim.nl/energietransitie) 

## Credits
  
This configuration repository was originally created by:
* Arjan Peddemors  ·  [@arpe](https://github.com/arpe)

It was extended by:
* Erik Krooneman · [@Erikker21](https://github.com/Erikker21)
* Leon Kampstra · [@LeonKampstra](https://github.com/LeonKampstra)
* Jorrin Kievit · [@JorrinKievit](https://github.com/JorrinKievit)
* Henri ter Hofte · [@henriterhofte](https://github.com/henriterhofte) · Twitter [@HeNRGi](https://twitter.com/HeNRGi)
  
Product owner:
* Henri ter Hofte · [@henriterhofte](https://github.com/henriterhofte) · Twitter [@HeNRGi](https://twitter.com/HeNRGi)

We use and gratefully acknowlegde the efforts of the makers of the following technologies:
* [Traefik proxy](https://github.com/traefik/traefik), by Traefik Labs, licensed under [MIT](https://github.com/traefik/traefik/blob/master/LICENSE.md)
* [Portainer](https://github.com/portainer/portainer), by Portainer.io, licensed under [Zlib](https://github.com/portainer/portainer/blob/develop/LICENSE)
* [MariaDB](https://github.com/MariaDB/server), licensed under [GNU GPL-2.0](https://github.com/MariaDB/server/blob/10.9/COPYING)
* [CloudBeaver](https://github.com/dbeaver/cloudbeaver), by DBeaver Corp, licensed under [Apache-2.0](https://github.com/dbeaver/cloudbeaver/blob/devel/LICENSE))
* [Duplicati](https://github.com/duplicati/duplicati), by duplicati.com, licensed under [LGPL-2.1](https://github.com/duplicati/duplicati/blob/master/LICENSE.txt)
* [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api), by Research group Energy Transition, Windesheim University of 
Applied Sciences, licensed under [Apache-2.0](https://github.com/energietransitie/twomes-backoffice-api/blob/main/LICENSE)
* [JupyterLab](https://github.com/jupyterlab/jupyterlab), by Project Jupyter Contributors, licensed under [this license](https://github.com/jupyterlab/jupyterlab/blob/master/LICENSE)
