mkdir /tmp/gvm-source
cd /tmp/gvm-source
git clone -b gvm-libs-11.0 https://github.com/greenbone/gvm-libs.git
git clone https://github.com/greenbone/openvas-smb.git
git clone -b openvas-7.0 https://github.com/greenbone/openvas.git
git clone -b ospd-2.0 https://github.com/greenbone/ospd.git
git clone -b ospd-openvas-1.0 https://github.com/greenbone/ospd-openvas.git
git clone -b gvmd-9.0 https://github.com/greenbone/gvmd.git
git clone -b gsa-9.0 https://github.com/greenbone/gsa.git

echo BUILDING GVM-LIBS

export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH
cd gvm-libs
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

echo BUILDING OPENVAS-SMB

cd ../../openvas-smb/
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

echo BUILDING OPENVAS

cd ../../openvas
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
sed -i 's/${COVERAGE_FLAGS}/-Werror -Wno-error=deprecated-declarations/g' ../../openvas/CMakeLists.txt
make
make install

#echo BUILDING REDIS
#
#exit
#ldconfig
#
#cp /tmp/gvm-source/openvas/config/redis-openvas.conf /etc/redis/
#chown redis:redis /etc/redis/redis-openvas.conf
#echo "db_address = /run/redis-openvas/redis.sock" > /opt/gvm/etc/openvas/openvas.conf
#chown gvm:gvm /opt/gvm/etc/openvas/openvas.conf
#usermod -aG redis gvm
#
#echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/openvas" > /etc/sudoers.d/gvm
#echo "gvm ALL = NOPASSWD: /opt/gvm/sbin/gsad" >> /etc/sudoers.d/gvm
#sudo sed -i 's#secure_path.*#Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/opt/gvm/sbin"#g' /etc/sudoers


export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH

echo BUILDING GVMD

cd ../../gvmd
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

echo BUILDING GSA

cd ../../gsa
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/opt/gvm
make
make install

echo BUILDING OSPD

export PKG_CONFIG_PATH=/opt/gvm/lib/pkgconfig:$PKG_CONFIG_PATH
mkdir -p /opt/gvm/lib/python3.8/site-packages/
export PYTHONPATH=/opt/gvm/lib/python3.8/site-packages

cd ../../ospd
python3 setup.py install --prefix=/opt/gvm

echo BUILDING OSPD-OPENVAS

export PYTHONPATH=/opt/gvm/lib/python3.8/site-packages
cd ../ospd-openvas
python3 setup.py install --prefix=/opt/gvm

