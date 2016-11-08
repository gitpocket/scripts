#!/bin/bash

CURL_CONF="/home/$USER/appfactory/etc/xl-release-curl.conf"

echo "$(tput setaf 2)Are you sure you want to delete ALL failed XLR releases?"
echo "Type \"$(tput setaf 3)YES$(tput setaf 2)\" to continue. Any other input will abort this script.$(tput sgr0)"
read ANSWER

if [ "${ANSWER,,}" == "yes" ]
then
  FAILED_RELEASES=$(curl -s -K $CURL_CONF -X GET localhost:5516/api/v1/releases | jq -r '.[] | select(.status=="FAILED") | .id')

  for FR in $FAILED_RELEASES
  do
    echo "Aborting and deleting release $(tput setaf 2)$FR$(tput sgr0)"
    curl -s -K $CURL_CONF -X POST localhost:5516/api/v1/releases/$FR/abort -o /dev/null
    curl -s -K $CURL_CONF -X DELETE localhost:5516/api/v1/releases/$FR -o /dev/null
  done
else
  echo "$(tput setaf 1)Confirmation not answered with \"Yes\". Aborting clean up.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Successfully completed script.$(tput sgr0)"
exit 0
