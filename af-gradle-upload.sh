#!/bin/bash

if [ -z $1 ]
then
  echo "$(tput setaf 1)No file provided$(tput sgr0)"
  exit 1
fi

lsof -i :8082 | grep LISTEN &> /dev/null
if [ $? != "0" ]; then
    echo "No tunnel to Jenkins on port 8082"
    exit 1
fi

JENKINS_ADDRESS="http://localhost:80822/"
GRADLEW_PATH="/home/$USER/appfactory/pipeline"
FILE_PATH=$(readlink -f $1)

if [ -z $IPA_USER ]
then
  echo "Enter user:"
  read $USERNAME
else
  USERNAME=$IPA_USER
fi

if [ -z $IPA_PASSWORD ]
then
  echo "Enter password:"
  read PASSWORD
else
  PASSWORD=$IPA_PASSWORD
fi

cd $GRADLEW_PATH

$GRADLEW_PATH/gradlew rest -Dpattern=$FILE_PATH -DbaseUrl=$JENKINS_ADDRESS -Dusername=$USERNAME -Dpassword=$PASSWORD
