#!/bin/sh

if [ -z ${1} ]
then
  echo "$(tput setaf 3)NOTICE: Statefile name not provided as parameter. Defaulting to terraform.$(tput sgr0)"
fi

DIR=`pwd`
TERRAFORMDIR="../terraform/"
STATEFILE="${1:-"terraform"}.tfstate"

cd /home/${USER}/github/appfactory/appfactory-poc/kubernetes/

if [ ! -f "${TERRAFORMDIR}${STATEFILE}" ]
then
  echo "$(tput setaf 1)ERROR: ${STATEFILE} does not exist in ${TERRAFORMDIR}.$(tput sgr0)"
  cd ${DIR}
  exit 1
fi

sh bootstrap-af.sh ${TERRAFORMDIR}${STATEFILE}
cd ${DIR}

echo "$(tput setaf 2)Done!$(tput sgr0)"
