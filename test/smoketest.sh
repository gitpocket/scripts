#!/bin/sh -l
set -e

#### TEMP
if [ -z "$1" ]
then
  echo "ERROR: Node variable empty. Exiting"
  exit
else
  NODE=$1
fi
####

ssh -o StrictHostKeyChecking=no core@$NODE "
echo 'Waiting for ETCD2 to come alive'
until /usr/bin/systemctl status etcd2 | grep 'active (running)' 2>/dev/null
do
  echo -n '.'
  sleep 3
done"
