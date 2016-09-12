#!/bin/bash

docker run --rm -v /home/dnon/src/github.com/nautsio/terraform/:/go/src/github.com/hashicorp/terraform -w /go/src/github.com/hashicorp/terraform  golang:1.6 bash -c "go get -d -v && make fmt && make dev"

echo "Finished building"

cp ~/src/github.com/nautsio/terraform/bin/terraform ~/bin/ && echo "$(tput setaf 2)Copied binary to /home/$USER/bin/$(tput sgr0)"
