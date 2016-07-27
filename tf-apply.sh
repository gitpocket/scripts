#!/bin/bash
if [ -z "$1" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=$1
fi


TOKEN=$(curl -s https://discovery.etcd.io/new | awk -F/ '{print $4}')

cat << EOF >> /home/$USER/etcd-token.log
========== $(date) ==========
Size:   3
Token:  $TOKEN

EOF

echo "Terraforming new environment with the following token:"
echo $TOKEN

terraform apply -var \'customer-prefix=${PREFIX}\' -var \'etcd-cluster-token=$TOKEN\' -var \'tradi-count=0\'
