#!/bin/bash
if [ -z $1 ]
then
  echo "$(tput setaf 2)Enter custmer prefix:$(tput sgr0)"
  read CUSTOMERPREFIX
else
  CUSTOMERPREFIX=$1
fi

TFDIR="/home/${USER}/src/github.com/nautsio/appfactory-poc/terraform/"
MODULE=$(cat ${TFDIR}/${CUSTOMERPREFIX}.tfstate | jq -r '.modules[1]["path"][1]')

terraform get ${TFDIR} &>/dev/null
MASTER=$(terraform output -state=${TFDIR}${CUSTOMERPREFIX}.tfstate -module=${MODULE} k8s-master.public_ips | awk -F"," '{print $1}')

ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o CheckHostIP=no -L 8080:127.0.0.1:8080 -L 5516:xlrelease-service.default.svc.appfactory.local:5516 -L 5601:kibana-logging.default.svc.appfactory.local:5601 -L 9200:elasticsearch.default.svc.appfactory.local:9200 -L 8082:jenkins.default.svc.appfactory.local:80 core@${MASTER}
