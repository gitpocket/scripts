#!/bin/bash
lsof -i :8081 | grep LISTEN &> /dev/null
if [ $? != "0" ]; then
    echo "No tunnel to Jenkins on port 8081"
    exit 1
fi

JENKINS_ADDRESS="http://localhost:8081/"
GRADLEW_PATH="/home/$USER/appfactory/pipeline"

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

$GRADLEW_PATH/gradlew rest -Dpattern=$1 -DbaseUrl=$JENKINS_ADDRESS -Dusername=$USERNAME -Dpassword=$PASSWORD
