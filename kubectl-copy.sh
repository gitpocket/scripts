#!/bin/bash
if [ -z "$1" ]
then
  echo "Enter the address of your CoreOS master:"
  read ADDRESS
else
  ADDRESS=$1
fi

echo "Copying KubeCTL"
scp core@$ADDRESS:/opt/bin/kubectl /usr/bin/kubectl
sudo chmod 0755 /usr/bin/kubectl

