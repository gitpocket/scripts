#!/bin/bash
if [ -z "$1" ]
then
  echo "$(tput setaf 1)No customer-prefix provided. Exiting.$(tput sgr0)"

  exit
else
  CUSTOMERPREFIX=$1
fi

# terraform show ~/github/appfactory/appfactory-poc/terraform/$PREFIX.tfstate | grep "^[[:space:]]*ip_address"
terraform get ../terraform/ &>/dev/null
echo "$(tput setaf 2)Master(s):$(tput sgr0)"
terraform output -state=/home/$USER/github/appfactory/appfactory-poc/terraform/${CUSTOMERPREFIX}.tfstate -module=kpnappfactory k8s-master.public_ips | sed 's/,/\n/g'
echo "$(tput setaf 2)Nodes:$(tput sgr0)"
terraform output -state=/home/$USER/github/appfactory/appfactory-poc/terraform/${CUSTOMERPREFIX}.tfstate -module=kpnappfactory k8s-node.public_ips | sed 's/,/\n/g'
