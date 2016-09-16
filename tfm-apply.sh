#!/bin/bash
if [ -z "${1}" ]
then
  echo "$(tput setaf 1)No customer-prefix provided. Exiting.$(tput sgr0)"
  exit
else
  PREFIX=${1}
fi

SIZE=${2:-"3"}

DIR="/home/${USER}/src/github.com/nautsio/appfactory-poc/terraform/"
STATEFILE="${DIR}${PREFIX}.tfstate"
VARFILE="${DIR}terraform.tfvars"

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${SIZE} | awk -F/ '{print $4}')

echo "$(tput setaf 2)Terraforming new environment with the following token:$(tput sgr0)"
echo ${TOKEN}

terraform get ${DIR}
terraform apply -var customer-prefix=${PREFIX} -var etcd-cluster-token=${TOKEN} -var tradi-count=0 -state=${STATEFILE} -var-file=${VARFILE} ${DIR}

