#!/bin/bash
if [ -z "${1}" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=${1}
fi

if [ -z "${2}" ]
then
  SIZE=3
else
  SIZE=${2}
fi

DIR="/home/${USER}/github/appfactory/appfactory-poc/terraform/"
STATEFILE="${DIR}${PREFIX}.tfstate"
VARFILE="${DIR}terraform.tfvars"

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${SIZE} | awk -F/ '{print $4}')

cat << EOF >> /home/${USER}/etcd-token.log
========== $(date) ==========
Size:   ${SIZE}
Prefix: ${PREFIX}
Token:  ${TOKEN}

EOF

echo "Terraforming new environment with the following token:"
echo ${TOKEN}

terraform get ${DIR}
terraform apply -var customer-prefix=${PREFIX} -var etcd-cluster-token=${TOKEN} -var tradi-count=0 -state=${STATEFILE} -var-file=${VARFILE} ${DIR}

