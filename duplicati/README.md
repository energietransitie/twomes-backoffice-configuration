# Duplicati

[Duplicati](https://www.duplicati.com/) is an online backup sotware solution.  

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

## Compose path

The compose path for this stack is:

### Production
```
duplicati/prd/docker-compose.yml
```

### Test
```
duplicati/tst/docker-compose.yml
```

## Environment variables

### `DB_PASSWORD`

This environment variable is used to set the database password.

Example values: `78sb6g654b56sdv7s89dv` or `as78sdv78sfdv67sdv5dc8sdv09sv`

### `IP_Whitelist`

This environment variable is used to set the allowed IPs (or ranges of allowed IPs by using CIDR notation).

Example values: `127.0.0.1/32, 192.168.1.7`

> Read more about it in the [Traefik documentation](https://doc.traefik.io/traefik/middlewares/http/ipwhitelist/).

## Additional steps

On the backup destination, create a directory for each environment (with the name `dev` and `prod`). For academic research in the Netherlands, [SURFdrive](https://www.surf.nl/surfdrive-bewaar-en-deel-je-bestanden-veilig-in-de-cloud?dst=n1460) or [Research Drive](https://wiki.surfnet.nl/display/RDRIVE/SURF+Research+Drive+wiki) might be a suitable backup destination in combination with the WebDAV protocol.

Use a web brower to navigate to [https://backup.energietransitiewindesheim.nl](https://backup.energietransitiewindesheim.nl) and [https://backup.tst.energietransitiewindesheim.nl](https://backup.tst.energietransitiewindesheim.nl), follow the wizard and use `Add backup` to add backup tasks using the option `Import from a file`. For convenience, we provided the files [backup_prod-duplicati-config.json](duplicati/backup_prod-duplicati-config.json) and [backup_dev-duplicati-config.json](duplicati/backup_dev-duplicati-config.json) as templates; add your own credentials and passphrases.

## Restore

Click restore and the environment and then the version you want to restore.

Check the `db.dump` and hit continue and restore.
