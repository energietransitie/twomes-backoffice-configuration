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

After the database is created for the first time, you can find the root password in the container logs. You can use this root password to log into the container and do any further configuration you wish. We recommend adding additional users with varying permissions.

See some useful queries below:

### Create a user

```sql
CREATE USER 'user'@'%' IDENTIFIED BY 'password';
```

### Add grants for user

```sql
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, CREATE ON database.* TO 'user'@'%';
```

#### Available grants

-   **CREATE** — enable users to create a database or table
-   **SELECT** — permit users to retrieve data
-   **INSERT** — let users add new entries in tables
-   **UPDATE** — allow users to modify existing entries in tables
-   **DELETE** — enable users to erase table entries
-   **DROP** — let users delete entire database tables

See even more grans [here](https://mariadb.com/kb/en/grant/#table-privileges)

### Flush privileges

You should do this after any grant changes.

```sql
FLUSH PRIVILEGES;
```

### Show grants

```sql
SHOW GRANTS FOR 'USER'@'%';
```

### Change password

```sql
ALTER USER 'user'@'%' IDENTIFIED BY 'password';
```

### Create a new database

```sql
CREATE DATABASE name;
```