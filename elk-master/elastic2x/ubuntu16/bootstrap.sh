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
apt-get install -y openjdk-7-jre

# install the Elastic PGP Key
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -





# Install Elasticsearch
# @see https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/2.4/es-release-notes.html
# @see https://www.elastic.co/guide/en/elasticsearch/reference/2.4/setup-repositories.html
echo "[INFO] Installing Elasticsearch..."

# install Elasticsearch
echo 'deb http://packages.elastic.co/elasticsearch/2.x/debian stable main' | \
	tee -a /etc/apt/sources.list.d/elasticsearch-2.x.list
apt-get update
apt-get install -y elasticsearch=2.4.4
update-rc.d elasticsearch defaults 95 10
systemctl start elasticsearch.service 2>&1

# copy over config
cp -R /vagrant/elasticsearch/* /etc/elasticsearch/
systemctl restart elasticsearch.service 2>&1





# install Logstash
# @see https://www.elastic.co/guide/en/logstash/2.4/installing-logstash.html
echo "[INFO] Installing Logstash..."
echo 'deb http://packages.elastic.co/logstash/2.4/debian stable main' | \
	tee /etc/apt/sources.list.d/logstash-2.4.x.list
apt-get update
apt-get install -y logstash=1:2.4.1-1
update-rc.d logstash defaults 96 9
systemctl start logstash.service 2>&1

# install the logstash-input-beats plugin
/opt/logstash/bin/logstash-plugin install logstash-input-beats

# copy over config files, test, restart
cp -R /vagrant/logstash/* /etc/logstash/conf.d/
systemctl restart logstash.service 2>&1





# Install Kibana
# @see https://www.elastic.co/guide/en/kibana/4.6/setup-repositories.html
echo "[INFO] Installing Kibana..."
echo 'deb http://packages.elastic.co/kibana/4.6/debian stable main' | \
	tee -a /etc/apt/sources.list.d/kibana-4.6.x.list
apt-get update
apt-get install -y kibana=4.6.4
update-rc.d kibana defaults 96 9
systemctl start kibana.service 2>&1

# copy over config, restart
touch /var/log/kibana.log
chmod 0666 /var/log/kibana.log
chown kibana:kibana /var/log/kibana.log
cp -R /vagrant/kibana/* /opt/kibana/config/
systemctl restart kibana.service 2>&1





# install the Beats dashboard
# https://github.com/elastic/beats-dashboards/releases 1.3.1, Aug 23, 2016
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
# @see https://www.elastic.co/guide/en/beats/libbeat/1.3/setup-repositories.html
echo "deb https://packages.elastic.co/beats/apt stable main" | \
	tee -a /etc/apt/sources.list.d/beats.list
apt-get update
apt-get install -y filebeat=1.3.1
update-rc.d filebeat defaults 95 10
systemctl start filebeat.service 2>&1

# copy over config files, restart, enable auto-start
mkdir -p /var/log/filebeat
cp -R /vagrant/filebeat/* /etc/filebeat/
systemctl restart filebeat.service 2>&1

# curl -XGET 'http://localhost:9200/filebeat-*/_search?pretty'





# Install Packetbeat
# https://www.elastic.co/guide/en/beats/packetbeat/1.3/packetbeat-installation.html#deb
apt-get install -y libpcap0.8
apt-get install -y packetbeat=1.3.1
update-rc.d packetbeat defaults 95 10
# service packetbeat start
systemctl start packetbeat.service 2>&1

# copy over config files, restart, enable auto-start
mkdir -p /var/log/packetbeat
cp -R /vagrant/packetbeat/* /etc/packetbeat/
systemctl restart packetbeat.service 2>&1

exit;




# Install Metricbeat
# https://www.elastic.co/guide/en/beats/metricbeat/5.2/metricbeat-installation.html#deb
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-5.2.1-amd64.deb
sudo dpkg -i metricbeat-5.2.1-amd64.deb





# Install Heartbeat
# https://www.elastic.co/guide/en/beats/heartbeat/5.2/heartbeat-installation.html#deb
curl -L -O https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-5.2.1-amd64.deb
sudo dpkg -i heartbeat-5.2.1-amd64.deb


# update file locator
updatedb
