#!/bin/bash

# create Prometheus datasource
curl -X POST http://admin:admin@grafana-route-myproject.127.0.0.1.nip.io/api/datasources -d @grafana-dashboards/datasource.json --header "Content-Type: application/json"
# deploy Kafka dashboard
curl -X POST http://admin:admin@grafana-route-myproject.127.0.0.1.nip.io/api/dashboards/db -d @grafana-dashboards/strimzi-kafka.json --header "Content-Type: application/json"
# deploy Zookeeper dashboard
curl -X POST http://admin:admin@grafana-route-myproject.127.0.0.1.nip.io/api/dashboards/db -d @grafana-dashboards/strimzi-zookeeper.json --header "Content-Type: application/json"