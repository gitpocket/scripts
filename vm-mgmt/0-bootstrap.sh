#!/bin/bash

echo "$(tput setab 2)$(tput setaf 0)Starting bootstrap script $(tput sgr0)"
# ROOT CHECK
if [ $EUID -ne 0 ]
then
  echo "$(tput setaf 1)ERROR: This script must be run as root. Exiting.$(tput sgr0)"
  exit 1
fi

# INPUT
echo "$(tput setaf 2)Enter your local username:$(tput sgr0)"
read USERNAME

if ! id $USERNAME
then
  echo "$(tput setaf 1)ERROR: $USERNAME is not an existing user. Exiting.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Enter your full name:$(tput sgr0)"
read FULLNAME

echo "$(tput setaf 2)Enter your KPN email address:$(tput sgr0)"
read EMAIL
if [[ "$EMAIL" != *@kpn.com ]]
then
  echo "$(tput setaf 1)ERROR: Not a KPN email address. Exiting.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Enter a password to be used for your GPG key:$(tput sgr0)"
read -s PASSWD
echo
if [ -z "$PASSWD" ]
then
  echo "$(tput setaf 1)ERROR: Password must not be empty. Exiting.$(tput sgr0)"
  exit 1
fi

echo "$(tput setaf 2)Re-type the password to confirm:$(tput sgr0)"
read -s PASSWD2
echo
if [[ "$PASSWD" != "$PASSWD2" ]]
then
  echo "$(tput setaf 1)ERROR: Passwords do not match. Exiting.$(tput sgr0)"
  exit 1
fi

# REPO
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

# PACKAGES
PACKAGES=( vim-enhanced net-tools docker-engine git java-1.8.0-openjdk rng-tools )
echo "$(tput setaf 2)Installing packages$(tput sgr0)"
for PACKAGE in ${PACKAGES[@]}
do
  yum install -y $PACKAGE >/dev/null
  echo "$PACKAGE installed"
done

echo "Installing Kubernetes Client"
curl https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl -o /tmp/kubectl
chmod +x kubectl
mv /tmp/kubectl /usr/local/bin/kubectl

# SERVICES
echo "$(tput setaf 2)Enabeling services$(tput sgr0)"
systemctl start docker
chkconfig docker on

# DOCKER GROUP
echo "$(tput setaf 2)Adding users to Docker group$(tput sgr0)"
USERS=($(ls /home/))
for USR in ${USERS[@]}
do
  usermod -aG docker $USR
  echo "$USR added"
done

# GIT CONFIG
echo "$(tput setaf 2)Setting up Git config for $USR$(tput sgr0)"
cat << EOF > /home/$USERNAME/.gitconfig
[user]
        email = $EMAIL
        name = $FULLNAME
[credential]
        helper = cache --timeout=3600
EOF
echo "Git config written to /home/$USERNAME/.gitconfig"
echo "$(tput setaf 2)Cloning AppFactory git repositories$(tput sgr0)"
GITDIR="/home/$USERNAME/src/github.com/nautsio/"
GITREPOS=( appfactory-poc terraform )
mkdir $GITDIR -p
echo "$(tput setaf 2)Enter your GitHub username:$(tput sgr0)"
read -s GHUSER
for REPO in ${GITREPOS[@]}
do
  su - $USERNAME -c "git clone https://github.com/nautsio/$REPO $GITDIR"
done

# GPG KEY
echo "$(tput setaf 2)Creating GPG key for $USERNAME $(tput sgr0)"

cat << EOF > /tmp/keyinfo
     Key-Type: default
     Subkey-Type: default
     Name-Real: $FULLNAME
     Name-Comment: KPN AppFactory
     Name-Email: $EMAIL
     Expire-Date: 1y
     Passphrase: $PASSWD
EOF

rngd -r /dev/urandom
su - $USERNAME -c "gpg --gen-key --batch /tmp/keyinfo" 
rm -f /tmp/keyinfo
GPGKEY=$(su - $USERNAME -c "gpg --list-secret-keys | tail -n 4 | grep ^sec")
# ---
# su - $USERNAME -c "gpg --send-keys $(echo $GPGKEY | awk -F'/' '{print $2}' | awk '{print $1}')
echo "place holder - this phase will send the following key to a keyserver:"
echo $GPGKEY
# ---
