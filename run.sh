#!/bin/bash

DATAVOL=/var/lib/openvas/
OV_PASSWORD=${OV_PASSWORD:-admin}
OV_UPDATE=${OV_UPDATE:0}

sudo redis-server /etc/redis/redis-openvas.conf &

#echo "Testing redis status..."
#X="$(redis-cli -s /run/redis-openvas/redis.sock)"
#while  [ "${X}" != "PONG" ]; do
#        echo "Redis not yet ready..."
#        sleep 1
#        X="$(redis-cli -s /run/redis-openvas/redis.sock ping)"
#done
#echo "Redis ready."
#
#echo
#echo "Initializing persistent directory layout"
#pushd /var/lib/openvas
#
#DATA_DIRS="CA cert-data mgr private/CA plugins scap-data"
#for dir in $DATA_DIRS; do
#	if [ ! -d $dir ]; then
#		mkdir $dir
#	fi
#done
#popd


# Check certs
#if [ ! -f /var/lib/openvas/CA/cacert.pem ]; then
#	/usr/bin/openvas-manage-certs -a
#fi

#if [ "$OV_UPDATE" == "yes" ];then
	greenbone-nvt-sync 2> ~/nvt_errors.log
	greenbone-certdata-sync 2> ~/certdata_errors.log
	greenbone-scapdata-sync 2> ~/scapdata_errors.log
	sudo openvas --update-vt-info
#fi

gvm-manage-certs -a

#if [  ! -d /usr/share/openvas/gsa/locale ]; then
#	mkdir -p /usr/share/openvas/gsa/locale
#fi

echo "Restarting services"
export PYTHONPATH=/opt/gvm/lib/python3.8/site-packages
/usr/bin/python3 /opt/gvm/bin/ospd-openvas \
	--pid-file /opt/gvm/var/run/ospd-openvas.pid \
	--log-file /opt/gvm/var/log/gvm/ospd-openvas.log \
	--lock-file-dir /opt/gvm/var/run -u /opt/gvm/var/run/ospd.sock
gvmd --osp-vt-update=/opt/gvm/var/run/ospd.sock
sudo gsad
