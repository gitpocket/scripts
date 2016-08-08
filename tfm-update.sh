#!/bin/bash
if [ -z "${1}" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=${1}
fi

DIR="/home/${USER}/github/appfactory/appfactory-poc/terraform/"
STATEFILE="${DIR}${PREFIX}.tfstate"
TOKEN=$(terraform show ${STATEFILE} | grep vars.etcd_cluster_token | awk -F' = ' '{print $2}')

echo "Updating $PREFIX "

terraform get ${DIR}
terraform apply -var customer-prefix=${PREFIX} -var etcd-cluster-token=${TOKEN} -var tradi-count=0 -state=${STATEFILE}

