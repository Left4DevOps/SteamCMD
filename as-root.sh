#!/bin/bash
microdnf -y install glibc.i686 \
    tar
microdnf -y update
microdnf clean all

useradd louis

mkdir             /steamapps /config
chown louis:louis /steamapps /config