# 
# Used for Docker Compose stuff.
# See https://github.com/cdrage/composefiles
#
# Must mount config.json to /etc/sensu/config.json !!
#
FROM debian:jessie

MAINTAINER Charlie Drage <charlie@charliedrage.com>

ENV DEBIAN_FRONTEND="noninteractive"

#! System preparation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y sudo wget git wget ruby ruby-dev openssl supervisor build-essential \
    && mkdir -p /var/log/supervisor

#! Sensu server
RUN wget -q http://repositories.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add - \
    && echo "deb     http://repositories.sensuapp.org/apt sensu main" | sudo tee /etc/apt/sources.list.d/sensu.list \
    && apt-get update \
    && apt-get install -y sensu


#! Install handler dependencies (mailer + slack)
RUN mkdir -p /etc/sensu/handlers \
    && /opt/sensu/embedded/bin/gem install sensu-plugin \
    && /opt/sensu/embedded/bin/gem install mail erubis

#! Add graphite tcp ruby file to handlers
ADD ./graphite-tcp.rb /etc/sensu/handlers/graphite-tcp.rb
ADD ./mailer.rb /etc/sensu/handlers/mailer.rb
ADD ./slack.rb /etc/sensu/handlers/slack.rb

#! Add supervisord
ADD ./supervisord.conf /etc/supervisord.conf

#! Sensu api port
EXPOSE 4567

CMD ["/usr/bin/supervisord"]
