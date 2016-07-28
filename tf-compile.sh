#!/bin/bash

docker run --rm -v ~/github/appfactory/terraform/:/go/src/github.com/hashicorp/terraform -w /go/src/github.com/hashicorp/terraform  golang:1.6 bash -c "go get -d -v && make fmt && make dev"

echo "Finished building"

sudo mv ~/github/appfactory/terraform/bin/terraform /usr/bin/

echo "Copied binary to /usr/bin/"
