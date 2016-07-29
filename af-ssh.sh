#!/bin/bash
IPADDRESS=$1

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o CheckHostIP=no core@${IPADDRESS}
