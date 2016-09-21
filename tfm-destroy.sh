#!/bin/bash
if [ -z "${1}" ]
then
  echo "$(tput setaf 1)No customer-prefix provided. Exiting.$(tput sgr0)"
  exit
else
  PREFIX=${1}
fi

DIR="/home/${USER}/src/github.com/nautsio/appfactory-poc/terraform/"
STATEFILE="${DIR}${PREFIX}.tfstate"
VARFILE="${DIR}terraform.tfvars"
 
PLATFORM=$(cat ${STATEFILE} | jq -r '.modules[1]["path"][1]')

if [[ $PLATFORM == "kpnappfactory" ]]
then
  cp ${DIR}main.azure ${DIR}main.tf
else
  cp ${DIR}main.$PLATFORM ${DIR}main.tf
fi

terraform get ${DIR}
terraform destroy -var customer-prefix=${PREFIX} -var etcd-cluster-token=0 -var tradi-count=0 -state=${STATEFILE} -var-file=${VARFILE} ${DIR}

if [ $(echo $?) -eq 0 ]
then
  rm -f ~/.ssh/known_hosts ${STATEFILE} ${STATEFILE}.backup
  echo "$(tput setaf 2)statefile removed$(tput sgr0)"
fi
