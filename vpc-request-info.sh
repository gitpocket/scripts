#!/bin/bash

if [[ $1 == *"https"* ]]
then
  REQUESTID=$(echo ${1} | awk -F= '{print $4}' | awk -F, '{print $1}')
  echo "$(tput setaf 2)Using request ID ${REQUESTID}$(tput sgr0)"
elif [ ! -z ${1} ]
then
  REQUESTID=${1}
else
  echo "$(tput setaf 1)No request ID given$(tput sgr0)"
  exit 1
fi

VARS="/home/${USER}/src/github.com/nautsio/appfactory-poc/etc/terraform.tfvars"

PASSWORD=$(grep ^vpc-password ${VARS} | awk -F= '{print $2}' | sed 's/ *"//g')
SERVER=$(grep ^vpc-vra_server ${VARS} | awk -F= '{print $2}' | sed 's/ *"//g')

TOKEN=$(curl -s --insecure -H "Accept: application/json" -H "Content-Type: application/json" --data "{\"username\":\"AppFactory@vpc.cloudnl\",\"password\":\"${PASSWORD}\",\"tenant\":\"AppFactory\"}" ${SERVER}/identity/api/tokens | awk -F'"' '{print $8}')

curl -v -s --insecure -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" ${SERVER}/catalog-service/api/consumer/requests/${REQUESTID} | jq . | less
