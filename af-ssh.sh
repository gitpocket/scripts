#!/bin/bash
if [ -z $1 ]
then
  echo "$(tput setaf 2)Enter IP address:$(tput sgr0)"
  read IPADDRESS
else
  IPADDRESS=$1
fi

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o CheckHostIP=no core@${IPADDRESS}
