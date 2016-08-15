#!/bin/bash
if [ -z "$1" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=$1
fi

ssh -A -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -L 8080:127.0.0.1:8080 core@${PREFIX}-appfactory0.westeurope.cloudapp.azure.com 
