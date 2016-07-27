#!/bin/bash

terraform show ~/github/appfactory/appfactory-poc/terraform/terraform.tfstate | grep "^[[:space:]]*ip_address"
