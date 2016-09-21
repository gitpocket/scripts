#!/bin/bash
if [ -z "${1}" ]
then
  echo "$(tput setaf 1)No customer-prefix provided. Exiting.$(tput sgr0)"
  exit
else
  PREFIX=${1}
fi

PLATFORM=${2:-"azure"}
if [[ ! "${PLATFORM}" =~ (azure|vpc) ]]
then
  echo "$(tput setaf 1)Unknown platform ${PLATFORM}$(tput sgr0)"
  exit 1
fi

SIZE=${3:-"3"}

DIR="/home/${USER}/src/github.com/nautsio/appfactory-poc/terraform/"
STATEFILE="${DIR}${PREFIX}.tfstate"
VARFILE="${DIR}terraform.tfvars"

cp ${DIR}main.${PLATFORM} ${DIR}main.tf

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${SIZE} | awk -F/ '{print $4}')

echo "$(tput setaf 2)Terraforming new environment on ${PLATFORM^^} with the following token:$(tput sgr0)"
echo ${TOKEN}

terraform get ${DIR}
#terraform apply -var customer-prefix=${PREFIX} -var etcd-cluster-token=${TOKEN} -var tradi-count=0 -state=${STATEFILE} -var-file=${VARFILE} ${DIR}

