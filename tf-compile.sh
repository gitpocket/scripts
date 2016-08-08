#!/bin/bash

docker run --rm -v /home/dnon/github/appfactory/terraform/:/go/src/github.com/hashicorp/terraform -w /go/src/github.com/hashicorp/terraform  golang:1.6 bash -c "go get -d -v && make fmt && make dev"

echo "Finished building"

sudo cp ~/github/appfactory/terraform/bin/terraform /usr/local/bin/ && echo "Copied binary to /usr/local/bin/"
