#!/bin/bash
if [ -z "$1" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=$1
fi

terraform destroy -var \'customer-prefix=${PREFIX}\' -var \'etcd-cluster-token=0\' -var \'tradi-count=0\'
