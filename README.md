# Twomes Backoffice Server Configuration

This repository contains configuration scripts and instructions for configuring a Twomes Backoffice server, comprising of multiple Docker containers hosted on a Linux server, based on the following technologies: [Traefik proxy](https://traefik.io/traefik/), [Portainer](https://www.portainer.io/), [MariaDB](https://mariadb.org/), [CloudBeaver](https://cloudbeaver.io/), [Duplicati](https://www.duplicati.com/), [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) and [JupyterLab](https://jupyter.org/).

NB: Where you read `energietransitiewindesheim.nl` below, you should subsitute your own domain; where you read `etw` below, you should subsitute your own server abbreviation. 

## Table of contents
* [Prerequisites](#prerequisites)
* [Deploying](#deploying)
    * [Traefik](#traefik)
    * [Portainer](#portainer)
    * [MariaDB](#mariadb)
    * [CloudBeaver](#cloudbeaver)
    * [Duplicati](#duplicati)
    * [API](#api)
    * [JupyterLab](#jupyterlab)
* [Updating](#updating)
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
- `db.energietransitiewindesheim.nl` : [cloudbeaver](#cloudbeaver)
- `deploy.energietransitiewindesheim.nl` : deploy webhook
- `backup.energietransitiewindesheim.nl` : [duplicati](#duplicati)

For JupyterLab notebooks (we use 3 JupyterLab notebooks, each in its own container):
- `jupyter.energietransitiewindesheim.nl` : [jupyter](#jupyterlab)
- `notebook.energietransitiewindesheim.nl` : [notebook](#jupyterlab)
- `analysis.energietransitiewindesheim.nl` : [analysis](#jupyterlab)

## Deploying

Use the following steps to deploy a service as a Portainer stack. 
> At Windesheim we use Portainer stacks, but the docker-compose files can also be deployed without Portainer, using [Docker Compose](https://docs.docker.com/get-started/08_using_compose/#run-the-application-stack).

Add a new stack according to the following steps:
1. Go to `stacks` in portainer.
2. Click on `Add stack`.
3. Give the stack a name.
4. Select `git repository` as the build method.
5. Set the `repository URL` to: 
    ```
    https://github.com/energietransitie/twomes-backoffice-configuration
    ```
6. Set the `repository reference` to:
    ```
    refs/heads/main
    ```
7. Set the `compose path` to point to the docker-compose.yml you want to deploy.
    > Refer to the chapters below to see the stack-specific compose path.
8. Optionally add environment variables if used in the docker-compose file. Click on `Add an environment variable` to add additional variables.
    > Refer to the chapters below to see the stack-specific environment variables.
9. Click on `Deploy the stack`.

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

[MariaDB](https://mariadb.org/) is an open source relational database. 

Follow the steps in the [deploying section](#deploying) to create the stack on Portainer, using the compose path below.

#### Compose path

The compose path for this stack is:

##### Production
```
mariadb/prd/docker-compose.yml
```

##### Test
```
mariadb/tst/docker-compose.yml
```

#### Environment variables

This stack does not require you to set any environment variables.

#### Additional steps

After the database is created for the first time, you can find the root password in the container logs. You can use this root password to log into the container and do any further configuration you wish. At Windesheim, we added additional users with varying permissions.

### CloudBeaver

[CloudBeaver](https://cloudbeaver.io/) is a web-based database manager.

Follow the steps in the [deploying section](#deploying) to create the stack on Portainer, using the compose path and environment variables below.

#### Compose path

The compose path for this stack is:

```
cloudbeaver/docker-compose.yml
```

#### Environment variables

##### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

### Duplicati

[Duplicati](https://www.duplicati.com/) is an online backup sotware solution.  

Follow the steps in the [deploying section](#deploying) to create the stack on Portainer, using the compose path and environment variables below.

#### Compose path

The compose path for this stack is:

```
duplicati/docker-compose.yml
```

#### Environment variables

##### `DB_PASSWORD_DEV`

This environment variable is used to set the database password for the test environment (mariadb_dev).

Example values: `78sb6g654b56sdv7s89dv` or `as78sdv78sfdv67sdv5dc8sdv09sv`

##### `DB_PASSWORD_PROD`

This environment variable is used to set the database password for the production environment (mariadb_prod).

Example values: `78sb6g654b56sdv7s89dv` or `as78sdv78sfdv67sdv5dc8sdv09sv`

##### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

#### Additional steps

On the backup destination, create a directory for each environment (with the name `dev` and `prod`). For academic research in the Netherlands, [SURFdrive](https://www.surf.nl/surfdrive-bewaar-en-deel-je-bestanden-veilig-in-de-cloud?dst=n1460) or [Research Drive](https://wiki.surfnet.nl/display/RDRIVE/SURF+Research+Drive+wiki) might be a suitable backup destination in combination with the WebDAV protocol.

Use a web brower to navigate to [https://backup.energietransitiewindesheim.nl](https://backup.energietransitiewindesheim.nl), follow the wizard and use `Add backup` to add backup tasks using the option `Import from a file`. For convenience, we provided the files [backup_prod-duplicati-config.json](duplicati/backup_prod-duplicati-config.json) and [backup_dev-duplicati-config.json](duplicati/backup_dev-duplicati-config.json) as templates; add your own credentials and passphrases.

#### Restore

Click restore and the environment and then the version you want to restore.

Check the `db.dump` and hit continue and restore.

### API

The [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) is an open souce solution that serves the Twomes REST API to the Twomes WarmteWachter app and Twomes measurement devices based on Twomes firmware and that used a Twomes database based on MariaDB. 

Follow the steps in the [deploying section](#deploying) to create the stack on Portainer, using the compose path and environment variables below.

#### Compose path

The compose path for this stack is:

##### Production
```
api/prd/docker-compose.yml
```

##### Test
```
api/tst/docker-compose.yml
```

#### Environment variables

##### `TWOMES_DB_URL`

This environment variable is used to set the database URL to connect to.

Example values: `readonly_researcher:correcthorsebatterystaple@mariadb_dev:3306/twomes`

> The composition of the connection string is as follows: `<db_user>:<db_password>@<db_host>:<db_port>/<db_name>`.
>
> It is recommended to use a user and password without special characters to avoid parsing errors.

### JupyterLab

[JupyterLab](https://jupyter.org/) is a web-based interactive development environment for notebooks, code, and data. 

Follow the steps in the [deploying section](#deploying) to create the stack on Portainer, using the compose path and environment variables below.

#### Compose path

The compose path for this stack is:

```
jupyter/docker-compose.yml
```

#### Environment variables

##### `TWOMES_DB_URL`

This environment variable is used to set the connection string which is used to connect to the Twomes database.

Example values: `readonly_researcher:correcthorsebatterystaple@mariadb_dev:3306/twomes`

> The composition of the connection string is as follows: `<db_user>:<db_password>@<db_host>:<db_port>/<db_name>`.
>
> It is recommended to use a user and password without special characters to avoid parsing errors.

##### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

#### Additional steps

After the container is fully started, you can use [Portainer](#portainer) to find the JupyterLab token in the logs. Search for `token` if don't see it immediately. To access the JupyterLab container, browse to this URL: `http://<subdomain>.energietransitiewindesheim.nl/lab?token=<jupyter_token>`. Make sure the name corresponds to an existing subdomain (at Windesheim, we use `jupyter`, `notebook` and `analysis` as subdomains for 3 JupyterLab instances).

> If this does not work immediately, wait a minute and try again (Traefik may not have processed the let's Encrypt certificate yet).

- Via the JupyterLab web interface:
    - Use the launcher (always avalable via the `+` tab), launch a terminal window and the command: 
    ```shell
    pip install jupyterlab-git
    ```
  - Enable Show hidden files via Settings / Advanced Settings editor / File Browser / Show hidden files.
  - Enable the Extension manager (puzzle icon in left pane).
  - If you wish to have a stable token after each forced restart, you can use [Portainer](#portainer), go to the container and via `Duplicate/Edit` > `Advanced container settings` > `Env` > `Add environment variable`, with name `JUPYTER_TOKEN` and a secret token with a proper length (e.g., 48 characters).
- Restart container via Portainer and access it again via the proper URL.
- Now, you can clone repositories, e.g. [twomes-twutility-inverse-grey-box-analysis](https://github.com/energietransitie/twomes-twutility-inverse-grey-box-analysis) via https://github.com/energietransitie/twomes-twutility-inverse-grey-box-analysis.git.

## Updating

When a `docker-compose.yml` for a stack is changed, the new configuration can be retrieved by following the steps below:

1. Go to `Stacks` [portainer](https://docker.energietransitiewindesheim.nl).
2. Click on the stack you want to update.
3. You can change environment variables if you want.
4. Click on `Pull and redeploy` to retrieve the configuration from the main branch and update the container(s).
5. A pop-up will open. Click on `Update` to confirm.
6. The stack will update. Wait for the notification to know that the stack was updated successfully.

## Features
List of features ready and TODOs for future development. Ready:

- [x] Implementing automated backup solution
- [x] Limiting access by IPv4 address
- [x] Ratelimiting on the API
- [x] Further implementation of Dependabot

To-do:
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
* Nick van Ravenzwaaij ·  [@n-vr](https://github.com/n-vr)
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
