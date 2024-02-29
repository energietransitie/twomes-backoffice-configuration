# Twomes Backoffice Server Configuration

This repository contains configuration scripts and instructions for configuring a Twomes Backoffice server, comprising of multiple Docker containers hosted on a Linux server, based on the following technologies: [Traefik proxy](https://traefik.io/traefik/), [Portainer](https://www.portainer.io/), [MariaDB](https://mariadb.org/), [CloudBeaver](https://cloudbeaver.io/), [Duplicati](https://www.duplicati.com/), [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) and [JupyterLab](https://jupyter.org/).

NB: Where you read `energietransitiewindesheim.nl` below, you should subsitute your own domain; where you read `etw` below, you should subsitute your own server abbreviation. 

## Table of contents
* [Prerequisites](#prerequisites)
* [Deploying](#deploying)
    * [Traefik](./traefik/README.md)
    * [Portainer](./portainer/README.md)
    * [MariaDB](./mariadb/README.md)
    * [CloudBeaver](./cloudbeaver/README.md)
    * [Duplicati](./duplicati/README.md)
    * [API](./api/README.md)
    * [Manuals](./manuals/README.md)
    * [JupyterLab](./jupyter/README.md)
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
- `api.energietransitiewindesheim.nl` : [api](./api/README.md)

For the Twomes backoffice test API:
- `api.tst.energietransitiewindesheim.nl` : [api](./api/README.md)

For the twomes production manuals:
- `manuals.energietransitiewindesheim.nl` : [manuals](./manuals/README.md)

For the twomes test manuals:
- `manuals.tst.energietransitiewindesheim.nl` : [manuals](./manuals/README.md)

For system services:
- `proxy.energietransitiewindesheim.nl` : [traefik](./traefik/README.md)
- `docker.energietransitiewindesheim.nl` : [portainer](./portainer/README.md)
- `db.energietransitiewindesheim.nl` : [cloudbeaver](./cloudbeaver/README.md)
- `deploy.energietransitiewindesheim.nl` : deploy webhook
- `backup.energietransitiewindesheim.nl` : [duplicati](./cloudbeaver/README.md)

For JupyterLab notebooks (we use 3 JupyterLab notebooks, each in its own container):
- `jupyter.energietransitiewindesheim.nl` : [jupyter](./jupyter/README.md)
- `notebook.energietransitiewindesheim.nl` : [notebook](./jupyter/README.md)
- `analysis.energietransitiewindesheim.nl` : [analysis](./jupyter/README.md)

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

See all subfolder README's for configuration specific to that service.

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
* Arjan Peddemors · [@arpe](https://github.com/arpe)

It was extended by:
* Nick van Ravenzwaaij · [@n-vr](https://github.com/n-vr)
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
