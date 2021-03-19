#!/usr/bin/env sh
#set -x
#echo GOPATH is $GOPATH
go get -u github.com/jvehent/pineapple 2>>&1 | tee /var/log/nginx/access.log
$GOPATH/bin/pineapple >>/var/log/nginx/access.log 2>&1 <<EOF
aws:
    region: eu-west-2
    accountnumber: 308362907713

components:
    - name: load-balancer
      type: elb
      tag:
          key: elasticbeanstalk:environment-name
          value: invoicer-api

    - name: application
      type: ec2
      tag: 
          key: elasticbeanstalk:environment-name
          value: invoicer-api

    - name: database
      type: rds
      tag:
          key: environment-name
          value: invoicer-api

#    - name: bastion
#      type: ec2
#      tag:
#          key: environment-name
#          value: invoicer-bastion

rules:
    - src: 0.0.0.0/0
      dst: load-balancer
      dport: 443

    - src: load-balancer
      dst: application
      dport: 80

    - src: application
      dst: database
      dport: 5432

#    - src: bastion
#      dst: application
#      dport: 22
#
#    - src: bastion
#      dst: database
#      dport: 5432
EOF
