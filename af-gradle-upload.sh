#!/bin/bash

if [ -z $1 ]
then
  echo "$(tput setaf 1)No file provided$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Enter customer prefix:$(tput sgr0)"
read PREFIX

DIR="/home/${USER}/src/github.com/nautsio/appfactory-poc"
STATEFILE="${DIR}/terraform/${PREFIX}.tfstate"
VARFILE="${DIR}/terraform/terraform.tfvars"
TOKEN=$(terraform show ${STATEFILE} | grep vars.etcd_cluster_token | awk -F' = ' '{print $2}')
PLATFORM=$(cat ${STATEFILE} | jq -r '.modules[1]["path"][1]')

JENKINS_ADDRESS="http://$MASTER_IP:8081/"
GRADLEW_PATH="$DIR/pipeline"
FILE_PATH=$(readlink -f $1)

if [ -z $IPA_USER ]
then
  echo "Enter user:"
  read USERNAME
else
  USERNAME=$IPA_USER
fi

if [ -z $IPA_PASSWORD ]
then
  echo "Enter password:"
  read -s PASSWORD
else
  PASSWORD=$IPA_PASSWORD
fi

cd $GRADLEW_PATH

$GRADLEW_PATH/gradlew rest -Dpattern=$FILE_PATH -DbaseUrl=$JENKINS_ADDRESS -Dusername=$USERNAME -Dpassword=$PASSWORD
