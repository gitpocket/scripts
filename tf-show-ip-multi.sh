#!/bin/bash
if [ -z "$1" ]
then
  echo "No customer-prefix provided. Exiting."
  exit
else
  PREFIX=$1
fi

terraform show ~/github/appfactory/$PREFIX/terraform.tfstate | grep "^[[:space:]]*ip_address"
