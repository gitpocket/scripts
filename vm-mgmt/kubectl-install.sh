#!/bin/bash

if [ "${EUID}" -ne "0" ]
then
  echo "$(tput setaf 1)Script must be run as root. Exiting.$(tput sgr0)"
  exit 1
fi

VERSION=${1:-"1.3.4"}

curl https://storage.googleapis.com/kubernetes-release/release/v${VERSION}/bin/linux/amd64/kubectl -o /tmp/kubectl
mv /tmp/kubectl /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl

echo "Installation complete"
