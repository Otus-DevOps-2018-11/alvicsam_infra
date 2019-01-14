#!/bin/bash
apt update
apt install -y ruby-full ruby-bundler build-essential
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
apt update
apt install -y mongodb-org
systemctl start mongod
systemctl enable mongod
cd /home/alvic
su alvic -c "git clone -b monolith https://github.com/express42/reddit.git /home/alvic/reddit"
cd /home/alvic/reddit
su alvic -c "bundle install"
su alvic -c "puma -d"

