# vagrant-elk

A vagrant based ELK stack (Elasticsearch, Logstash, Kibana).

Installation:
```shell
vagrant up
# open a browser
# http://127.0.0.1:5601
# under "Index Patterns", click "filebeat-*"
# click the green star, setting the default pattern
# click "Discover", in the top menu
# click drop-down in left-side menu, select "filebeat-*"
```

## Notes

The following ELK components are installed:
- Elasticsearch 2.4.1 (September 29, 2016)
- Logstash 2.4.0 (August 31, 2016)
- Kibana 4.6.2 (October 24, 2016)
- Filbeat 1.3.1 (September 15, 2016)

https://www.elastic.co/downloads/past-releases



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
