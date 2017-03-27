# elk

A vagrant based ELK stack (Elasticsearch, Logstash, Kibana).

Installation:
```shell
vagrant box update
vagrant up

# open a browser
# http://127.0.0.1:5601
# under "Index name or pattern", type "filebeat-*"
# under "Time-field name", select "@timestamp"
# click "Create"
# on the next page, click the green star, setting the default index

# click "Discover", in the top menu
# click drop-down in left-side menu, select "filebeat-*"
# you may have to wait a few minutes for the results to flow in
```

## Notes

The following ELK components are installed:

elastic2x
- Elasticsearch 2.4.3 (December 13, 2016)
- Logstash 		2.4.1 (November 9, 2016)
- Kibana 		4.6.3 (November 15, 2016)
- Filebeat 		1.3.1 (September 15, 2016)

elastic5x
- Elasticsearch 5.2.2 (February 24, 2017)
- Logstash 		5.2.2 (February 24, 2017)
- Kibana 		5.2.2 (February 24, 2017)
- Filebeat 		5.2.2 (February 24, 2017)
- Packetbeat 	5.2.2 (February 24, 2017)
- Metricbeat 	5.2.2 (February 24, 2017)

https://www.elastic.co/downloads/past-releases



## Log files
```shell

# filebeat
/var/log/filebeat/filebeat.log

# logstash
/var/log/filebeat/filebeat.log
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
