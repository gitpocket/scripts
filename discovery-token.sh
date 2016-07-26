#!/bin/bash
if [ -z "$1" ]
then
  echo "Enter initial cluster size:"
  read CLUSTERSIZE
else
  CLUSTERSIZE=$1
fi

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${CLUSTERSIZE} | awk -F/ '{print $4}')

cat << EOF >> /home/dnon/logs/discovery-token.log
===== GENERATED ON $(date) =====
By:     $USER
Size:   $CLUSTERSIZE
Token:  $TOKEN

EOF

echo "New ETCD Discovery Token:"
echo $TOKEN
