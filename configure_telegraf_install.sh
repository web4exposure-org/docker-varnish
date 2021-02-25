#!/bin/bash

cat <<EOF | sudo tee /etc/apt/sources.list.d/influxdata.list
deb https://repos.influxdata.com/ubuntu bionic stable
EOF
curl -sL https://repos.influxdata.com/influxdb.key | apt-key add -
