# elk

A vagrant based ELK stack (Elasticsearch, Logstash, Kibana).

## Installation

```shell
vagrant box update
vagrant up

# open a browser
# http://127.0.0.1:5601
# under "Index name or pattern", type "filebeat-*"
# under "Time-field name", select "@timestamp"
# click "Create"
# on the next page, click the (green/blue) star, setting the default index

# click "Discover", in the top menu
# click drop-down in left-side menu, select "filebeat-*"
# you may have to wait a few minutes for the results to flow in
```

## Versions

The following ELK components are installed:

elastic2x
- Elasticsearch 2.4.3 (December 13, 2016)
- Logstash 		2.4.1 (November 9, 2016)
- Kibana 		4.6.3 (November 15, 2016)
- Filebeat 		1.3.1 (September 15, 2016)

elastic5x
- Elasticsearch 5.3.0 (March 28, 2017)
- Logstash 		5.3.0 (March 29, 2017)
- Kibana 		5.3.0 (March 28, 2017)
- Filebeat 		5.3.0 (March 28, 2017)
- Packetbeat 	5.2.2 (March 28, 2017)
- Metricbeat 	5.2.2 (March 28, 2017)


## Release Notes

Elastic
https://www.elastic.co/downloads/past-releases

Elasticsearch
https://github.com/elastic/elasticsearch/releases
https://www.elastic.co/guide/en/elasticsearch/reference/current/es-release-notes.html

Logstash
https://github.com/elastic/logstash/releases
https://www.elastic.co/guide/en/logstash/current/releasenotes.html

Kibana
https://github.com/elastic/kibana/releases
https://www.elastic.co/guide/en/kibana/current/release-notes.html

Beats
https://github.com/elastic/beats/releases



## Log files
```shell

# filebeat
/var/log/filebeat/filebeat.log

# metricbeat
/var/log/metricbeat/metricbeat

# heartbeat
/var/log/heartbeat/heartbeat

# logstash
/var/log/logstash/logstash-plain.log
/var/log/logstash/logstash.stdout
/var/log/logstash/logstash.log

# elasticsearch
/var/log/elasticsearch/elasticsearch.log
/var/log/elasticsearch/elasticsearch.log.*
/var/log/elasticsearch/elasticsearch_deprecation.log
/var/log/elasticsearch/elasticsearch_index_search_slowlog.log
/var/log/elasticsearch/elasticsearch_index_indexing_slowlog.log.log

# kibana
/var/log/kibana.log
/var/log/kibana/kibana.stderr
/var/log/kibana/kibana.stdout
```



## Application folders
```shell

# elasticsearch
/etc/elasticsearch/

# logstash
/etc/logstash

# kibana
/opt/kibana

# filebeat
/etc/filebeat
```
