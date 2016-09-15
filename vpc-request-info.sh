#!/bin/bash

#mother of if-statements 
if [[ ${1} == *"https"* ]]
then
  #REQUESTID=$(echo ${ID} | awk -F= '{print $4}' | awk -F, '{print $1}')
  REQUESTID=$(echo ${1} | sed 's/.*requestId\:\=//' | sed 's/\,actionId.*//')
  echo "$(tput setaf 2)Using request ID $(tput sgr0)"
  echo "${REQUESTID}"
elif [ ! -z ${1} ]
then
  REQUESTID=${1}
else
  echo "$(tput setaf 2)Enter VPC request ID:$(tput sgr0)"
  read ID
  if [[ ${ID} == *"https"* ]]
    then
    #REQUESTID=$(echo ${ID} | awk -F= '{print $4}' | awk -F, '{print $1}')
    REQUESTID=$(echo ${ID} | sed 's/.*requestId\:\=//' | sed 's/\,actionId.*//')
    echo "$(tput setaf 2)Using request ID:$(tput sgr0)"
    echo "${REQUESTID}"
  elif [ ! -z ${ID} ]
  then
    REQUESTID=${ID}
  else
    echo "$(tput setaf 1)No request ID given$(tput sgr0)"
    exit 1
  fi
fi

#validate requestID format
if [[ ! ${REQUESTID} =~ .{8}-.{4}-.{4}-.{4}-.{12} ]]
then
  echo "$(tput setaf 1)Request ID not valid$(tput sgr0)"
  exit 1
fi

#tfvars location
VARS="/home/${USER}/src/github.com/nautsio/appfactory-poc/etc/terraform.tfvars"

#extract secrets from tfvars
PASSWORD=$(grep ^vpc-password ${VARS} | awk -F= '{print $2}' | sed 's/ *"//g')
SERVER=$(grep ^vpc-vra_server ${VARS} | awk -F= '{print $2}' | sed 's/ *"//g')

#get VPC token
TOKEN=$(curl -s --insecure -H "Accept: application/json" -H "Content-Type: application/json" --data "{\"username\":\"AppFactory@vpc.cloudnl\",\"password\":\"${PASSWORD}\",\"tenant\":\"AppFactory\"}" ${SERVER}/identity/api/tokens | awk -F'"' '{print $8}')

#retrieve vpc request json
curl -v -s --insecure -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" ${SERVER}/catalog-service/api/consumer/requests/${REQUESTID} | jq . | less
