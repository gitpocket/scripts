#!/bin/bash
if [ -z "$1" ]
then
  echo "Enter initial cluster size:"
  read CLUSTERSIZE
else
  CLUSTERSIZE=$1
fi

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${CLUSTERSIZE} | awk -F/ '{print $4}')

cat << EOF >> /home/$USER/discovery-token.log
========== $(date) ==========
Size:   $CLUSTERSIZE
Token:  $TOKEN

EOF

echo "New ETCD Discovery Token:"
echo $TOKEN
