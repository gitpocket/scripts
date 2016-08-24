#!/bin/bash
if [ -z "${1}" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=${1}
fi

DIR="/home/${USER}/src/github.com/nautsio/appfactory-poc/terraform/"
STATEFILE="${DIR}${PREFIX}.tfstate"
VARFILE="${DIR}terraform.tfvars"

rm -f ~/.ssh/known_hosts

terraform get ${DIR}
terraform destroy -var customer-prefix=${PREFIX} -var etcd-cluster-token=0 -var tradi-count=0 -state=${STATEFILE} -var-file=${VARFILE} ${DIR}

