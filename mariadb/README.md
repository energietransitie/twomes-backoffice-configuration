# MariaDB

[MariaDB](https://mariadb.org/) is an open source relational database. 

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

## Compose path

The compose path for this stack is:

### Production
```
mariadb/prd/docker-compose.yml
```

### Test
```
mariadb/tst/docker-compose.yml
```

## Environment variables

This stack does not require you to set any environment variables.

## Additional steps

After the database is created for the first time, you can find the root password in the container logs. You can use this root password to log into the container and do any further configuration you wish. At Windesheim, we added additional users with varying permissions.
