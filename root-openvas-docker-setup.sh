echo BUILDING REDIS

ldconfig

cp /tmp/gvm-source/openvas/config/redis-openvas.conf /etc/redis/
chown redis:redis /etc/redis/redis-openvas.conf
echo "db_address = /run/redis-openvas/redis.sock" > /opt/gvm/etc/openvas/openvas.conf
mkdir /run/redis-openvas/
chown gvm:gvm /run/redis-openvas/
chown gvm:gvm /opt/gvm/etc/openvas/openvas.conf
usermod -aG redis gvm

echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/openvas" > /etc/sudoers.d/gvm
echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/gsad" >> /etc/sudoers.d/gvm
echo "gvm ALL = NOPASSWD: /usr/bin/redis-server" >> /etc/sudoers.d/gvm
sudo sed -i 's#.*secure_path.*#Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/opt/gvm/sbin"#g' /etc/sudoers

