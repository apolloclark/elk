#!/usr/bin/env bash

# set the ELK package versions
ELASTIC_VERSION="5.3.0"
ELASTICSEARCH_VERSION=$ELASTIC_VERSION
LOGSTASH_VERSION=$ELASTIC_VERSION
KIBANA_VERSION=$ELASTIC_VERSION
FILEBEAT_VERSION=$ELASTIC_VERSION
PACKETBEAT_VERSION=$ELASTIC_VERSION
METRICBEAT_VERSION=$ELASTIC_VERSION
HEARTBEAT_VERSION=$ELASTIC_VERSION





# set the installation to be non-interactive
export DEBIAN_FRONTEND="noninteractive"

# update aptitude
apt-get update
apt-get upgrade -y
apt-get install -y unzip git

# enable colored Bash prompt
cp /vagrant/bashrc /root/.bashrc
cp /vagrant/bashrc /home/vagrant/.bashrc

# enable more robust Nano syntax highlighting
git clone https://github.com/scopatz/nanorc.git /root/.nano
cat /root/.nano/nanorc >> /root/.nanorc
git clone https://github.com/scopatz/nanorc.git /home/vagrant/.nano
cat /home/vagrant/.nano/nanorc >> /home/vagrant/.nanorc

# install Java
apt-get purge openjdk*
add-apt-repository ppa:openjdk-r/ppa 2>&1
apt-get update
apt-get install -y openjdk-8-jdk





# install the Elastic PGP Key and repo
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo 'deb https://artifacts.elastic.co/packages/5.x/apt stable main' | \
	tee -a /etc/apt/sources.list.d/elastic-5.x.list
apt-get update





# Install Elasticsearch
# @see https://github.com/elastic/elasticsearch/releases
# @see https://www.elastic.co/downloads/elasticsearch
# @see https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/5.2/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/5.2/deb.html
echo "[INFO] Installing Elasticsearch..."
apt-get install -y elasticsearch=$ELASTICSEARCH_VERSION
update-rc.d elasticsearch defaults 95 10
service elasticsearch start

# copy over config, restart, enable auto-start
cp -R /vagrant/elasticsearch/* /etc/elasticsearch/
service elasticsearch restart





# install Logstash
# @see https://github.com/elastic/logstash/releases
# @see https://www.elastic.co/guide/en/logstash/current/releasenotes.html
# @see https://www.elastic.co/guide/en/logstash/5.2/installing-logstash.html
echo "[INFO] Installing Logstash..."
apt-get install -y logstash=1:$LOGSTASH_VERSION-1
initctl start logstash

# copy over config files, restart
cp -R /vagrant/logstash/* /etc/logstash/conf.d/
initctl restart logstash





# Install Kibana
# @see https://github.com/elastic/kibana/releases
# @see https://www.elastic.co/guide/en/kibana/current/release-notes.html
# @see https://www.elastic.co/guide/en/kibana/5.2/deb.html
echo "[INFO] Installing Kibana..."
apt-get install -y kibana=$KIBANA_VERSION
update-rc.d kibana defaults 96 9
service kibana start

# copy over config, restart
cp -R /vagrant/kibana/* /etc/kibana/
service kibana restart 2>&1





# Beats
# https://github.com/elastic/beats/releases	5.2.2

# Install Filebeat
# https://github.com/elastic/beats
# @see https://www.elastic.co/guide/en/beats/libbeat/5.2/setup-repositories.html
echo "[INFO] Installing Filbeat..."
apt-get install -y filebeat=$FILEBEAT_VERSION
update-rc.d filebeat defaults 95 10
service filebeat start 2>&1

# copy over config files, restart
mkdir -p /var/log/filebeat
cp -R /vagrant/filebeat/* /etc/filebeat/
service filebeat restart 2>&1

# curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'





# Install Packetbeat
# https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-installation.html#deb
echo "[INFO] Installing Packetbeat..."
apt-get install -y libpcap0.8
apt-get install -y packetbeat=$PACKETBEAT_VERSION
update-rc.d packetbeat defaults 95 10
service packetbeat start 2>&1

# copy over config files, restart
mkdir -p /var/log/packetbeat
cp -R /vagrant/packetbeat/* /etc/packetbeat/
service packetbeat restart 2>&1





# Install Metricbeat
# https://www.elastic.co/guide/en/beats/metricbeat/5.2/metricbeat-installation.html#deb
# curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.2.1-amd64.deb
# sudo dpkg -i metricbeat-5.2.1-amd64.deb
echo "[INFO] Installing Metricbeat..."
apt-get install -y metricbeat=$METRICBEAT_VERSION
update-rc.d metricbeat defaults 95 10
service metricbeat start 2>&1

# copy over config files, restart
mkdir -p /var/log/metricbeat
cp -R /vagrant/metricbeat/* /etc/metricbeat/
service metricbeat restart 2>&1





# Install Heartbeat
# https://www.elastic.co/guide/en/beats/heartbeat/5.2/heartbeat-installation.html#deb
echo "[INFO] Installing Heartbeat..."
apt-get install -y heartbeat=$HEARTBEAT_VERSION
update-rc.d heartbeat defaults 95 10
service heartbeat start 2>&1

# copy over config files, restart
mkdir -p /var/log/heartbeat
cp -R /vagrant/heartbeat/* /etc/heartbeat/
service heartbeat restart 2>&1





# clear out unneeded packages
apt-get autoremove -y

# update file search cache
updatedb
