#!/bin/bash
if [ -z "${1}" ]
then
  echo "Enter the prefix of your CoreOS master:"
  read PREFIX
else
  PREFIX=${1}
fi

echo "Copying KubeCTL"
scp core@${PREFIX}-appfactory0.westeurope.cloudapp.azure.com:/opt/bin/kubectl ~/ # /usr/bin/kubectl
# sudo chmod 0755 /usr/bin/kubectl

