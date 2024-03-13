# Manuals

The [Twomes Manual Server](https://github.com/energietransitie/twomes-manual-server) is an open souce solution that serves the twomes manuals.

Follow the steps in the [deploying section of the main README](../README.md#deploying) to create the stack on Portainer, using the compose path and environment variables below.

## Compose path

The compose path for this stack is:

### Production
```
manuals/prd/docker-compose.yml
```

### Test
```
manuals/tst/docker-compose.yml
```

## Environment variables

### `TWOMES_MANUAL_SOURCE`

This environment variable is used to set the source of the twomes manuals.

Example values: `/source` or `https://github.com/<org>/<repo>`

### `TWOMES_FALLBACK_LANG`

This environment variable is used to set the fallback language for serving the twomes manuals.

Example values: `en-GB` or `nl-NL`
