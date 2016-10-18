#!/bin/bash

RECIPIENTS=$(sed -rn 's/^.*\-recipient\s*(.*)\s\\$/\1/p' /home/$USER/appfactory/etc/encrypt.sh)

for r in $RECIPIENTS
do
  gpg --search-keys $r
  gpg --edit-key $r trust
done
