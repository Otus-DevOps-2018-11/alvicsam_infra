#!/bin/bash

set -e

cd
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
sudo mv /tmp/reddit.service /etc/systemd/system/reddit.service
sudo systemctl daemon-reload
sudo systemctl enable reddit
sudo systemctl start reddit