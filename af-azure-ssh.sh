#!/bin/bash

PREFIX=$1

ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o CheckHostIP=no -L 8080:127.0.0.1:8080 -L 5516:xlrelease-service.default.svc.appfactory.local:5516 -L 5601:kibana-logging.default.svc.appfactory.local:5601 -L 9200:elasticsearch.default.svc.appfactory.local:9200 core@${PREFIX}-appfactory0.westeurope.cloudapp.azure.com
