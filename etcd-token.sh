#!/bin/bash
if [ -z "$1" ]
then
  echo "No cluster size provided. Using default value (3)."
  CLUSTERSIZE=3
else
  CLUSTERSIZE=$1
fi

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${CLUSTERSIZE} | awk -F/ '{print $4}')

cat << EOF >> /home/$USER/etcd-token.log
========== $(date) ==========
Size:   $CLUSTERSIZE
Token:  $TOKEN

EOF

echo "New ETCD Discovery Token:"
echo $TOKEN
