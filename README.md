# vagrant-elk

A vagrant based ELK stack (Elasticsearch, Logstash, Kibana).

Installation:
```shell
vagrant up
# open a browser
# http://127.0.0.0:5601
# under "Index Patterns", click "filebeat-*"
# click the green star, setting the default pattern
# click "Discover", in the top menu
# click drop-down in left-side menu, select "filebeat-*"
```



## Log files
```shell
# elasticsearch
/var/log/elasticsearch/elasticsearch.log
/var/log/elasticsearch/elasticsearch_index_search_slowlog.log
/var/log/elasticsearch/elasticsearch_index_search_slowlog.log
/var/log/elasticsearch/elasticsearch_deprecation.log

# logstash
/var/log/logstash/logstash.log
/var/log/logstash/logstash.stdout
/var/log/logstash/logstash.err

# kibana
/var/log/kibana/kibana.stdout
/var/log/kibana/kibana.stderr

# filebeat
/var/log/filebeat/filebeat.log



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