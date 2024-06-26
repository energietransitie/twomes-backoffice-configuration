# NeedForHeat Server Configuration <!-- omit from toc -->
![GitHub License](https://img.shields.io/github/license/energietransitie/needforheat-server-configuration)
![Project Status badge](https://img.shields.io/badge/status-in%20progress-brightgreen)
![Version Status Badge](https://img.shields.io/badge/version-stable-brightgreen)

This repository contains configuration scripts and instructions for configuring a NeedForHeat Server, comprising of multiple Docker containers hosted on a Linux server, based on the following technologies: [Traefik proxy](https://traefik.io/traefik/), [Portainer](https://www.portainer.io/), [MariaDB](https://mariadb.org/), [CloudBeaver](https://cloudbeaver.io/), [Duplicati](https://www.duplicati.com/), [NeedForHeat Server API](https://github.com/energietransitie/needforheat-server-api) and [JupyterLab](https://jupyter.org/).

NB: Where you read `example.com` below, you should subsitute your own domain (we use `energietransitiewindesheim.nl`). 

<!-- omit from toc -->
## Table of contents
- [Prerequisites](#prerequisites)
  - [Server and Domain](#server-and-domain)
  - [SSH setup](#ssh-setup)
  - [Subdomains](#subdomains)
- [Deploying](#deploying)
  - [Setting up Traefik and Portainer](#setting-up-traefik-and-portainer)
  - [Deploying stacks with Portainer](#deploying-stacks-with-portainer)
- [Updating](#updating)
- [Features](#features)
- [License](#license)
- [Credits](#credits)

## Prerequisites

### Server and Domain

Before you begin, ensure you have the following:

- **Server**: You'll need access to a server, such as a virtual private server (VPS). We've tested on:
  - A Virtual Private Server running Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-107-generic x86_64), equipped with 58GB of memory and 1.9TB of disk space.
  - A Synology DS923+ NAS running GNU/Linux synology_r1000_923+ with 32GB of memory and 8.1TB of disk space.

- **Domain**: You should have a domain, like `example.com`, properly configured in DNS to point to your server(s). If you're using our configuration, replace `example.com` with your domain in all configuration files.

- **Environment Setup**: We recommend a test and a production environment, each on separate servers:
  - Production URL: `<service>.example.com`
  - Test URLs: `<service>.tst.example.com`

> Note: If your domain is newly registered, it may take up to 48 hours for DNS changes to propagate worldwide. You can use tools like [DNS checker](https://dnschecker.org/) to monitor the status of these changes.


### SSH setup

For easy ssh/scp access to the server, copy your ssh certificate to
the server. This requires the root password once; after that, your
ssh key will be used for authentication.

Open a Linux command window on your local system. On Windows, you can use e.g. [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) for this. 

Generate a public/private key pair (files `.ssh/nfh.pub` and `.ssh/nfh`)
```shell
ssh-keygen -f ~/.ssh/nfh
```

When asked for passphrase, leave that empty.

Now, upload your public key to the server.
```shell
ssh-copy-id -i ~/.ssh/nfh root@example.com
```

Login with ssh, without using a password
```shell
ssh -i ~/.ssh/nfh root@example.com
```

Append the following to your `.ssh/config`
```text
Host nfh
User root
HostName example.com
IdentityFile ~/.ssh/nfh
```

With this config in place, login to the server is simply
```shell
ssh nfh
```


### Subdomains

For public services we suggest:

| Public Service                 | Production URL        | Test URL                  |
| ------------------------------ | --------------------- | ------------------------- |
| [API](./api/README.md)         | `api.example.com`     | `api.tst.example.com`     |
| [Manuals](./manuals/README.md) | `manuals.example.com` | `manuals.tst.example.com` |

For system services we suggest:

| System Service                         | Production URL                | Test URL                          |
| -------------------------------------- | ----------------------------- | --------------------------------- |
| [Portainer](./portainer/README.md)     | `portainer.example.com`       | `portainer.tst.example.com`       |
| [CloudBeaver](./cloudbeaver/README.md) | `cloudbeaver.example.com`     | `cloudbeaver.tst.example.com`     |
| [Duplicati](./duplicati/README.md)     | `duplicati.example.com`       | `duplicati.tst.example.com`       |
| [JupyterLab](./jupyter/README.md)      | `analysis-<name>.example.com` | `analysis-<name>.tst.example.com` |

You may want to consider adding an additional layer of protection for system services, e.g. VPN and/or IP whitelisting.

## Deploying

### Setting up Traefik and Portainer

This setup has to be done with SSH access to the server. During these steps, portainer is shorly exposed to the public internet without protection of credentials or IP whitelists.

1. Log into the server using SSH and run the following commands on your Docker host.
1. Create volumes acme.json file for Traefik and volumes for Portainer:
    ```bash
    mkdir -p /opt/traefik && \
    { [ -f /opt/traefik/acme.json ] || touch /opt/traefik/acme.json; } && \
    chmod 600 /opt/traefik/acme.json && \
    docker network create web && \
    docker volume create portainer-bootstrap_data && \
    docker volume create portainer_data && \
    docker run -d --rm -p 9443:9443 --name portainer-bootstrap \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer-bootstrap_data:/data \
    portainer/portainer-ce:latest
    ```
   This multi-line command:
   - creates an acme.json file for Traefik to store certificates in;
   - creates the web network for containers to share;
   - creates two Docker volumes:
     - `portainer-bootstrap_data` for the bootstrapping process;
     - `portainer_data` for persistent data storage for the Portainer application.
   - starts a Portainer container named `portainer-bootstrap` using the `portainer-bootstrap_data` volume for bootstrapping.

3. Access the bootstrap Portainer web interface in your browser at `https://server-external-ip-address:9443`. Enter a username and password for the initial administrator when prompted.

4. Use these [Portainer stack parameters](portainer/README.md) to [deploy a stack](#deploying-stacks-with-portainer) for Portainer.

5. Use these [Traefik stack parameters](traefik/README.md) to [deploy a stack](#deploying-stacks-with-portainer) for Traefik.

6. Stop the bootstrapping container and remove the related volume:
    ```bash
    docker stop portainer-bootstrap && \
    docker volume rm portainer-bootstrap_data
    ```
   This stops and removes the `portainer-bootstrap` container and removes the `portainer-bootstrap_data` volume used for bootstrapping.

7. Restart Portainer to apply the configurations:
    ```bash
    docker restart portainer
    ```

8. Portainer is now available at `portainer.<YOUR_DOMAIN>`, for example, `portainer.example.com`.


### Deploying stacks with Portainer

Use the following steps to deploy a service as a Portainer stack. 
> We use Portainer stacks, but the docker-compose files can also be deployed without Portainer, using [Docker Compose](https://docs.docker.com/get-started/08_using_compose/#run-the-application-stack).

Add a new stack according to the following steps:
1. Go to `Home` > `local ` > `stacks` in portainer.
1. Click on `Add stack`.
1. Give the stack a name.
1. Select `git repository` as the build method.
1. Set the `repository URL` to: 
    ```
    https://github.com/energietransitie/needforheat-server-configuration
    ```
1. Set the `repository reference` to:
    ```
    refs/heads/main
    ```
1. Set the `compose path` to point to the docker-compose.yml you want to deploy.
    > Refer to the stack-specific README's for each stack's compose path.
1. Optionally add environment variables if used in the docker-compose file. Click on `Add an environment variable` to add additional variables.
    > Refer to the stack-specific README's for each stack's environment variables.
1. Click on `Deploy the stack`.

## Updating

When a `docker-compose.yml` for a stack is changed, the new configuration can be retrieved by following the steps below:

1. Go to `Stacks` in [portainer](https://portainer.example.com).
1. Click on the stack you want to update.
1. You can change environment variables if you want.
1. Click on `Pull and redeploy` to retrieve the configuration from the main branch and update the container(s).
1. A pop-up will open. Click on `Update` to confirm.
1. The stack will update. Wait for the notification to know that the stack was updated successfully.

## Features
List of features ready and TODOs for future development. Ready:

- [x] Implementing automated backup solution
- [x] Limiting access by IPv4 address
- [x] Ratelimiting on the API
- [x] Further implementation of Dependabot

To-do:
- [ ] Create only docker-compose file for Traefik instead of .toml files
- [ ] Integrated deployment of the entire NeedForHeat Server stack

Optional:
- [ ] force use of SSH tunnel to `portainer` container
- [ ] force use of SSH tunnel to `cloudbeaver` container
- [ ] force use of SSH tunnel to `traefik` container

## License

This software is available under the [Apache 2.0 license](./LICENSE), 
Copyright 2022 [Research group Energy Transition, Windesheim University of 
Applied Sciences](https://windesheim.nl/energietransitie) 

## Credits
  
This configuration repository was originally created by:
* Arjan Peddemors · [@arpe](https://github.com/arpe)

It was extended by:
* Harris Mesic · [@Labhatorian](https://github.com/Labhatorian)
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
* [NeedForHeat Server API](https://github.com/energietransitie/needforheat-server-api), by Research group Energy Transition, Windesheim University of 
Applied Sciences, licensed under [Apache-2.0](https://github.com/energietransitie/needforheat-server-api/blob/main/LICENSE)
* [JupyterLab](https://github.com/jupyterlab/jupyterlab), by Project Jupyter Contributors, licensed under [this license](https://github.com/jupyterlab/jupyterlab/blob/master/LICENSE)
