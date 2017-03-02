#!/usr/bin/env bash
# @see https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
# @see https://qbox.io/blog/qbox-a-vagrant-virtual-machine-for-elasticsearch-2-x
# @see https://github.com/Asquera/elk-example
# @see https://github.com/bhaskarvk/vagrant-elk-cluster



# set the installation to be non-interactive
export DEBIAN_FRONTEND="noninteractive"

# update aptitude
apt-get update
apt-get install -y unzip




# install the Elastic PGP Key
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -




# Install Elasticsearch
# @see https://www.elastic.co/downloads/elasticsearch
# @see https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/5.2/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/5.2/deb.html
echo "[INFO] Installing Elasticsearch..."

# install Java
apt-get purge openjdk*
apt-get -y install openjdk-7-jdk

# install Elasticsearch
echo 'deb https://artifacts.elastic.co/packages/5.x/apt stable main' | \
	tee -a /etc/apt/sources.list.d/elasticsearch-5.x.list
apt-get update
exit;
apt-get install -y elasticsearch=5.2.1
service elasticsearch start

# copy over config
cp -R /vagrant/elasticsearch/* /etc/elasticsearch/
service elasticsearch restart
update-rc.d elasticsearch defaults 95 10





# install Logstash
# @see https://www.elastic.co/guide/en/logstash/5.2/installing-logstash.html
echo "[INFO] Installing Logstash..."
apt-get update
apt-get install -y logstash=1:5.2.1-1
service logstash start

# copy over config files, test, restart
cp -R /vagrant/logstash/* /etc/logstash/conf.d/
service logstash configtest
service logstash restart
update-rc.d logstash defaults 96 9





# Install Kibana
# @see https://www.elastic.co/guide/en/kibana/5.2/deb.html
echo "[INFO] Installing Kibana..."
apt-get update
apt-get install -y kibana=5.2.1
service kibana start

# copy over config, restart
cp -R /vagrant/kibana/* /opt/kibana/config/
service kibana restart
update-rc.d kibana defaults 96 9





# install the Beats dashboard
# https://github.com/elastic/beats-dashboards/releases 1.3.1
cd ~
curl -L -O -s https://download.elastic.co/beats/dashboards/beats-dashboards-1.3.1.zip
unzip -q beats-dashboards-*.zip
cd beats-dashboards-*
./load.sh > /dev/null 2>&1

# install the Filebeat template
cd ~
curl -O -s https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
curl -XPUT -s 'http://localhost:9200/_template/filebeat?pretty' -d@filebeat-index-template.json
# verify the output is {"acknowledged" : true}





# Beats
# https://github.com/elastic/beats/releases	5.2.1


# Install Filebeat
# @see https://www.elastic.co/guide/en/beats/libbeat/5.2/setup-repositories.html
apt-get update
apt-get install -y filebeat=5.2.1
service filebeat start

# copy over config files, restart, enable auto-start
mkdir -p /var/log/filebeat
cp -R /vagrant/filebeat/* /etc/filebeat/
service filebeat restart 2>&1
update-rc.d filebeat defaults 95 10

# curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'





# Install Packetbeat
# https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-installation.html#deb
apt-get install -y libpcap0.8
apt-get install -y packetbeat=5.2.1
service packetbeat start

# copy over config files, restart, enable auto-start
mkdir -p /var/log/packetbeat
cp -R /vagrant/packetbeat/* /etc/packetbeat/
service packetbeat restart 2>&1
update-rc.d packetbeat defaults 95 10

exit;




# Install Metricbeat
# https://www.elastic.co/guide/en/beats/metricbeat/5.2/metricbeat-installation.html#deb
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.2.1-amd64.deb
sudo dpkg -i metricbeat-5.2.1-amd64.deb





# Install Heartbeat
# https://www.elastic.co/guide/en/beats/heartbeat/5.2/heartbeat-installation.html#deb
curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.2.1-amd64.deb
sudo dpkg -i heartbeat-5.2.1-amd64.deb



updatedb
