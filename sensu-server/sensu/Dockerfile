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


#! Install all handlers
RUN mkdir -p /etc/sensu/handlers \
    && gem install sensu-plugin \
    && gem install mail erubis \
    && wget -O /etc/sensu/handlers/mailer.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-mailer/master/bin/handler-mailer.rb \
    && chmod +x /etc/sensu/handlers/mailer.rb \
    && wget -O /etc/sensu/handlers/slack.rb https://raw.githubusercontent.com/sensu-plugins/sensu-plugins-slack/master/bin/handler-slack.rb \
    && chmod +x /etc/sensu/handlers/slack.rb

# Add graphite tcp ruby file to handlers
ADD ./graphite-tcp.rb /etc/sensu/handlers/graphite-tcp.rb

#! Add supervisord
ADD ./supervisord.conf /etc/supervisord.conf

#! Sensu api port
EXPOSE 4567

CMD ["/usr/bin/supervisord"]
