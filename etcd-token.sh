#!/bin/bash
if [ -z "$1" ]
then
  echo "No cluster size provided. Using default value (3)."
fi

CLUSTERSIZE=${1:-"3"}

TOKEN=$(curl -s https://discovery.etcd.io/new?size=${CLUSTERSIZE} | awk -F/ '{print $4}')

echo "$(tput setaf 2)New ETCD Discovery Token:$(tput sgr0)"
echo $TOKEN
