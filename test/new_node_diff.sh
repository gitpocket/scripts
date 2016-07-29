#!/bin/bash

oldState=$(terraform show | grep 'computer_name' | awk -F'= ' '{print $2}')

###>>>> this is where the new node should be rolled out <<<<###

newState=$(terraform show | grep 'computer_name' | awk -F'= ' '{print $2}')

NODE=$(diff -u <(echo "$oldState") <(echo "$newState") | grep "+[a-z]" | awk -F'+' '{print $2}')
