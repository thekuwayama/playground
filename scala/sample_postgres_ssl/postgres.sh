#!/bin/sh

docker run -d -p 5432:5432 --name postgres \
       -e POSTGRES_HOST_AUTH_METHOD=trust \
       -v "$(pwd)/server.crt:/var/lib/postgresql/server.crt:ro" \
       -v "$(pwd)/server.key:/var/lib/postgresql/server.key:ro" \
       -v "$(pwd)/root.crt:/var/lib/postgresql/root.crt:ro" \
       postgres:12-alpine \
       -c ssl=on \
       -c ssl_cert_file=/var/lib/postgresql/server.crt \
       -c ssl_key_file=/var/lib/postgresql/server.key \
       -c ssl_ca_file=/var/lib/postgresql/root.crt
