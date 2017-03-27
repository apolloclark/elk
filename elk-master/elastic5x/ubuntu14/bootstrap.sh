#!/usr/bin/env bash
# @see https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
# @see https://qbox.io/blog/qbox-a-vagrant-virtual-machine-for-elasticsearch-2-x
# @see https://github.com/Asquera/elk-example
# @see https://github.com/bhaskarvk/vagrant-elk-cluster



# set the installation to be non-interactive
export DEBIAN_FRONTEND="noninteractive"

# update aptitude
apt-get update
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
# @see https://www.elastic.co/downloads/elasticsearch
# @see https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/5.2/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/5.2/deb.html
echo "[INFO] Installing Elasticsearch..."
apt-get install -y elasticsearch=5.2.2
service elasticsearch start

# copy over config, restart, enable auto-start
cp -R /vagrant/elasticsearch/* /etc/elasticsearch/
service elasticsearch restart
update-rc.d elasticsearch defaults 95 10





# install Logstash
# @see https://www.elastic.co/guide/en/logstash/current/releasenotes.html
# @see https://www.elastic.co/guide/en/logstash/5.2/installing-logstash.html
echo "[INFO] Installing Logstash..."
apt-get install -y logstash=1:5.2.2-1
initctl start logstash

# copy over config files, test, restart
cp -R /vagrant/logstash/* /etc/logstash/conf.d/
initctl restart logstash





# Install Kibana
# @see https://www.elastic.co/guide/en/kibana/5.2/deb.html
echo "[INFO] Installing Kibana..."
apt-get install -y kibana=5.2.2
service kibana start

# copy over config, restart, enable auto-start
cp -R /vagrant/kibana/* /etc/kibana/
service kibana restart 2>&1
update-rc.d kibana defaults 96 9





# Beats
# https://github.com/elastic/beats/releases	5.2.2

# Install Filebeat
# @see https://www.elastic.co/guide/en/beats/libbeat/5.2/setup-repositories.html
echo "[INFO] Installing Filbeat..."
apt-get install -y filebeat=5.2.2
service filebeat start 2>&1

# copy over config files, restart, enable auto-start
mkdir -p /var/log/filebeat
cp -R /vagrant/filebeat/* /etc/filebeat/
service filebeat restart 2>&1
update-rc.d filebeat defaults 95 10

# curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'





# Install Packetbeat
# https://www.elastic.co/guide/en/beats/packetbeat/current/packetbeat-installation.html#deb
echo "[INFO] Installing Packetbeat..."
apt-get install -y libpcap0.8
apt-get install -y packetbeat=5.2.2
service packetbeat start 2>&1

# copy over config files, restart, enable auto-start
mkdir -p /var/log/packetbeat
cp -R /vagrant/packetbeat/* /etc/packetbeat/
service packetbeat restart 2>&1
update-rc.d packetbeat defaults 95 10





# Install Metricbeat
# https://www.elastic.co/guide/en/beats/metricbeat/5.2/metricbeat-installation.html#deb
# curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.2.1-amd64.deb
# sudo dpkg -i metricbeat-5.2.1-amd64.deb
echo "[INFO] Installing Metricbeat..."
apt-get install -y metricbeat=5.2.2
service metricbeat start 2>&1
update-rc.d metricbeat defaults 95 10





# Install Heartbeat
# https://www.elastic.co/guide/en/beats/heartbeat/5.2/heartbeat-installation.html#deb
echo "[INFO] Installing Heartbeat..."
apt-get install -y heartbeat=5.2.2
service heartbeat start 2>&1
update-rc.d heartbeat defaults 95 10





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





# update file search cache
updatedb
