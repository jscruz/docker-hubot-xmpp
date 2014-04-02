# Docker container with with simple things for tesing things and things.

FROM ubuntu:13.10
MAINTAINER Matthew Sawasy "sawasy@gmail.com"

# Update repos!
RUN apt-get -q update

# Patch All the things!
RUN apt-get -qy upgrade

# Install some fun things!
RUN apt-get install -qy --force-yes zsh supervisor nodejs npm redis-server

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN npm install -g hubot coffee-script

RUN hubot --create .

RUN chmod 755 bin/hubot 

ADD hubot-scripts.json hubot-scripts.json

# Add the URL for the repo's tarball as a mount point
ADD https://github.com/markstory/hubot-xmpp/tarball/master /mnt/

# Untar the repo-slash-mountpoint
RUN tar -xvf /mnt/master -C / && mv /markstory-hubot-xmpp* /hubot-xmpp

RUN cd hubot-xmpp && npm install

RUN npm install node-stringprep

ADD package.json package.json

run   mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

env HUBOT_AUTH_ADMIN <CHANGEME_USERNAME>
env HUBOT_XMPP_USERNAME <CHANGEME_USERNAME>
env HUBOT_XMPP_PASSWORD <CHANGEME_PASSWORD>
# Optional
# env HUBOT_XMPP_ROOMS <CHANGEME_ROOM>

cmd   supervisord -n
