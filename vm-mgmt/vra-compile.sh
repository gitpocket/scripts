#!/bin/bash
cd ${GOPATH}/src/github.com/nautsio/terraform-provider-vrealize
make install
echo "$(tput setaf 2)Finished building$(tput sgr0)"
