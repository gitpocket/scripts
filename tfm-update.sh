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
TOKEN=$(terraform show ${STATEFILE} | grep vars.etcd_cluster_token | awk -F' = ' '{print $2}')

echo "$(tput setaf 2)Updating $PREFIX $(tput sgr0)"

terraform get ${DIR}
terraform apply -var customer-prefix=${PREFIX} -var etcd-cluster-token=${TOKEN} -var tradi-count=0 -state=${STATEFILE} -var-file=${VARFILE} ${DIR}

