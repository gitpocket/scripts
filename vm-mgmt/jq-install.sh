#!/bin/sh
if [ $EUID -ne 0 ]
then
  echo "$(tput setaf 1)ERROR: This script must be run as root. Exiting.$(tput sgr0)"
  exit 1
fi

yum -y install wget gcc

wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz

tar -xf jq-1.5.tar.gz
cd jq-1.5

./configure && make && sudo make install

cd ..
rm -rf jq-1.5 jq-1.5.tar.gz
