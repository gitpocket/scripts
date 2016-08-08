#!/bin/bash
if [ -z "$1" ]
then
  echo "$(tput setaf 1)No customer-prefix provided. Exiting.$(tput sgr0)"

  exit
else
  PREFIX=$1
fi

terraform show ~/github/appfactory/appfactory-poc/terraform/$PREFIX.tfstate | grep "^[[:space:]]*ip_address"
