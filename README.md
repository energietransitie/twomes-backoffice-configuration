# Twomes Backoffice Server Configuration <!-- omit from toc -->

This repository contains configuration scripts and instructions for configuring a Twomes Backoffice server, comprising of multiple Docker containers hosted on a Linux server, based on the following technologies: [Traefik proxy](https://traefik.io/traefik/), [Portainer](https://www.portainer.io/), [MariaDB](https://mariadb.org/), [CloudBeaver](https://cloudbeaver.io/), [Duplicati](https://www.duplicati.com/), [Twomes Backoffice API](https://github.com/energietransitie/twomes-backoffice-api) and [JupyterLab](https://jupyter.org/).

NB: Where you read `energietransitiewindesheim.nl` below, you should subsitute your own domain; where you read `etw` below, you should subsitute your own server abbreviation. 

<!-- omit from toc -->
## Table of contents
- [Prerequisites](#prerequisites)
  - [SSH setup](#ssh-setup)
  - [Domain setup](#domain-setup)
- [Deploying](#deploying)
  - [Setting up Traefik and Portainer](#setting-up-traefik-and-portainer)
  - [Deploying stacks with Portainer](#deploying-stacks-with-portainer)
- [Updating](#updating)
- [Features](#features)
- [Status](#status)
- [License](#license)
- [Credits](#credits)

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

We have production (prd) and test (tst) environment, each on a separate server. The production and test environment can be destinguished by their URL.
- Production URL's: `<service>.energietransitiewindesheim.nl`
- Test URL's: `<service>.tst.energietransitiewindesheim.nl`

If you wish to copy our configuration, then you will need to find and replace `energietransitiewindesheim.nl` with your own domain in all configuration files.

The URL's we use for our public services:

| Service                        | Environment |                                         URL |
| ------------------------------ | ----------- | ------------------------------------------: |
| [API](./api/README.md)         | production  |         `api.energietransitiewindesheim.nl` |
| [API](./api/README.md)         | test        |     `api.tst.energietransitiewindesheim.nl` |
| [Manuals](./manuals/README.md) | production  |     `manuals.energietransitiewindesheim.nl` |
| [Manuals](./manuals/README.md) | test        | `manuals.tst.energietransitiewindesheim.nl` |

The URL's we use for system services:

| Service                                | Environment |                                                 URL |
| -------------------------------------- | ----------- | --------------------------------------------------: |
| [Portainer](./portainer/README.md)     | production  |              `docker.energietransitiewindesheim.nl` |
| [Portainer](./portainer/README.md)     | test        |          `docker.tst.energietransitiewindesheim.nl` |
| [CloudBeaver](./cloudbeaver/README.md) | production  |                  `db.energietransitiewindesheim.nl` |
| [CloudBeaver](./cloudbeaver/README.md) | test        |              `db.tst.energietransitiewindesheim.nl` |
| [Duplicati](./duplicati/README.md)     | production  |              `backup.energietransitiewindesheim.nl` |
| [Duplicati](./duplicati/README.md)     | test        |          `backup.tst.energietransitiewindesheim.nl` |
| [JupyterLab](./jupyter/README.md)      | production  |     `analysis-<name>.energietransitiewindesheim.nl` |
| [JupyterLab](./jupyter/README.md)      | test        | `analysis-<name>.tst.energietransitiewindesheim.nl` |

## Deploying

### Setting up Traefik and Portainer

This setup has to be done with SSH access to the server. During these steps, portainer is shorly exposed to the public internet without protection of credentials or IP whitelists.

1. Log into the server using SSH.
2. Create a volume for portainer:
    ```bash
    docker volume create portainer_data
    ```
3. Start the container:
    ```bash
    docker run -d --rm -p 9443:9443 --name portainer-bootstrap \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest
    ```
4. Open Portainer in your browser: `https://server-external-ip-address:9443`.
5. Add portainer and traefik as a stack by following the steps described [here](#deploying-stacks-with-portainer).
6. Stop the bootstrapping container:
    ```bash
    docker stop portainer-bootstrap
    ```
7. Restart portainer:
    ```bash
    docker restart portainer
    ```
8. Portainer is now available at `docker.energietransitiewindesheim.nl`.

### Deploying stacks with Portainer

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
    > Refer to the stack-specific README's for each stack's compose path.
8. Optionally add environment variables if used in the docker-compose file. Click on `Add an environment variable` to add additional variables.
    > Refer to the stack-specific README's for each stack's environment variables.
9. Click on `Deploy the stack`.

## Updating

When a `docker-compose.yml` for a stack is changed, the new configuration can be retrieved by following the steps below:

1. Go to `Stacks` in [portainer](https://docker.energietransitiewindesheim.nl).
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
