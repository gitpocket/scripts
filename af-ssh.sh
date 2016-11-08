#!/bin/bash
if [ -z $1 ]
then
  echo "$(tput setaf 2)Enter custmer prefix:$(tput sgr0)"
  read CUSTOMERPREFIX
else
  CUSTOMERPREFIX=$1
fi

NAMESPACE=${2:-"platform"}

WORKDIR="/home/$USER/src/github.com/nautsio/appfactory-poc"

if [ "$CUSTOMERPREFIX" == "af" ]
then
  TFSTATE="$WORKDIR/af-tfstate/terraform.tfstate"
else
  TFSTATE="$WORKDIR/terraform/${CUSTOMERPREFIX}.tfstate"
fi

MODULE=$(cat $TFSTATE | jq -r '.modules[1]["path"][1]')

terraform get $WORKDIR/terraform &>/dev/null
MASTER=$(terraform output -state=$TFSTATE -module=$MODULE k8s-master.public_ips | awk -F"," '{print $1}')

ssh -A -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o CheckHostIP=no -L 8080:127.0.0.1:8080 -L 5516:xlrelease-service.${NAMESPACE}.svc.appfactory.local:5516 -L 5601:kibana-logging.${NAMESPACE}.svc.appfactory.local:5601 -L 9200:elasticsearch.${NAMESPACE}.svc.appfactory.local:9200 core@${MASTER}
