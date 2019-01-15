#!/bin/bash

oc exec -ti $(oc get pod -l app=tech-exchange-kafka-connect -o=jsonpath='{.items[0].metadata.name}') -- curl -X POST -H "Content-Type: application/json" --data '{ "name": "echo-sink-test", "config": { "connector.class": "EchoSink", "tasks.max": "3", "topics": "my-topic", "level": "INFO" } }' http://localhost:8083/connectors