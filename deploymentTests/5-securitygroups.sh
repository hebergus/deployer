#!/usr/bin/env sh
set -x
#echo GOPATH is $GOPATH
go get -u github.com/jvehent/pineapple 2>>&1 | tee /var/log/nginx/access.log