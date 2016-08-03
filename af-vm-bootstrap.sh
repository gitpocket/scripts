#!/bin/bash
echo "$(tput setaf 2)$(tput sgr0)"
if [[ $EUID -ne 0 ]];
then
  echo "$(tput setaf 1)ERROR: This script must be run as root. Exiting.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Enter your local username:$(tput sgr0)"
read USERNAME

if id $USERNAME
  echo "$(tput setaf 1)ERROR: $USERNAME is not an existing user. Exiting.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Enter your full name:$(tput sgr0)"
read FULLNAME

echo "$(tput setaf 2)Enter your KPN email address:$(tput sgr0)"
read EMAIL

echo "$(tput setaf 2)Creating Docker repository$(tput sgr0)"
cat << EOF >> /etc/yum.repos.d/docker.repo
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
ls /etc/yum.repos.d/docker.repo

PACKAGES=( net-tools docker-engine git java-1.8.0-openjdk kubernetes-client )
echo "$(tput setaf 2)Installing packages$(tput sgr0)"
for PACKAGE in ${PACKAGES[@]}
do
  yum install -y $PACKAGE >/dev/null
  echo "$PACKAGE installed"
done

echo "$(tput setaf 2)Enabeling services$(tput sgr0)"
systemctl start docker
chkconfig docker on

echo "$(tput setaf 2)Adding users to Docker group$(tput sgr0)"
USERS=($(ls /home/))
for USR in ${USERS[@]}
do
  usermod -aG docker $USR
  echo "$USR added"
done

echo "$(tput setaf 2)Setting up Git config for $USR$(tput sgr0)"
cat << EOF > /home/$USERNAME/.gitconfig
[user]
        email = $EMAIL
        name = $FULLNAME
[credential]
        helper = cache --timeout=3600
EOF
echo "Git config written to /home/$USERNAME/.gitconfig"
