#!/bin/bash
mkdir ssl
cd ssl
wget http://sensuapp.org/docs/0.21/files/sensu_ssl_tool.tar
tar -xvf sensu_ssl_tool.tar --strip-components=1
./ssl_certs.sh generate
rm -r sensu_ssl_tool.tar ssl_certs.sh

echo ""
echo "SSL files have been generated to /ssl"
echo "Use these certs for sensu-server validation"
echo ""
