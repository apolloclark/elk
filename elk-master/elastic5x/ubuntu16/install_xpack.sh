#!/usr/bin/env bash

# set the installation to be non-interactive
export DEBIAN_FRONTEND="noninteractive"

# Install X-Pack
# https://www.elastic.co/guide/en/x-pack/current/installing-xpack.html
echo "[INFO] Installing X-Pack... this will take like 25+ minutes..."
/var/lib/dpkg/info/ca-certificates-java.postinst configure

# https://www.elastic.co/guide/en/elasticsearch/reference/5.5/installing-xpack-es.html#xpack-package-installation
cd /usr/share/elasticsearch
bin/elasticsearch-plugin install x-pack --batch
service elasticsearch restart 2>&1

# https://www.elastic.co/guide/en/kibana/5.5/installing-xpack-kb.html
cd /usr/share/kibana
service elasticsearch stop 2>&1
date +%s
bin/kibana-plugin install x-pack
date +%s
service kibana restart 2>&1

# https://www.elastic.co/guide/en/logstash/5.5/installing-xpack-log.html
cd /usr/share/logstash
service logstash stop 2>&1
bin/logstash-plugin install x-pack
service logstash restart 2>&1
sleep 30
service elasticsearch restart 2>&1
sleep 30
