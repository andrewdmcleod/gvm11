#!/bin/bash

OV_PASSWORD=${OV_PASSWORD:-admin}
OV_UPDATE=${OV_UPDATE:0}

echo -n "Checking for scanners: "
SCANNER=$(sudo -Hiu gvm gvmd --get-scanners)
echo "Done"

if [ "$SCANNER" == "" ] ; then
        echo "Adding scanner"
        sudo -Hiu gvm gvmd --create-scanner="OpenVAS Scanner" --scanner-type="OpenVAS" --scanner-host=/opt/gvm/var/run/ospd.sock
fi

# Check for users, and create admin
if ! [[ $(sudo -Hiu gvm gvmd --get-users) ]] ; then
        sudo -Hiu gvm gvmd --create-user=admin
        sudo -Hiu gvm gvmd --user=admin --new-password=$OV_PASSWORD
fi

if [ -n "$OV_PASSWORD" ]; then
        echo "Setting admin password"
        sudo -Hiu gvm gvmd --user=admin --new-password=$OV_PASSWORD
fi

if [ -z "$BUILD" ]; then
        echo "Tailing logs"
        tail -F /opt/gvm/var/log/gvm/*
fi

