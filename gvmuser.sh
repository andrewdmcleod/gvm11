#!/bin/bash
mkdir /opt/gvm
useradd -r -d /opt/gvm -c "GVM User" -s /bin/bash gvm
chown gvm:gvm /opt/gvm
