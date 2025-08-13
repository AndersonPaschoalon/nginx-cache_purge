#!/bin/bash


wget https://nginx.org/download/nginx-1.29.0.tar.gz
tar -zxvf nginx-1.29.0.tar.gz


wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz
tar -zxvf  ngx_cache_purge-2.3.tar.gz


wget https://raw.githubusercontent.com/nginx-modules/ngx_cache_purge/master/config
cp config ngx_cache_purge-2.3/config


rm config
rm *.tar.gz







