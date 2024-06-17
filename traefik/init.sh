#!/bin/bash

# Ensure acme.json exists
touch /acme.json
chmod 600 /acme.json

# Continue with other setup if needed
exec "$@"
