# Build it:
# docker build -t $USER/sensu-server .
# 
# Run it:
# docker run \
#   -p 3000:3000 \
#   -p 4567:4567 \
#   -p 5671:5671 \
#   -p 15672:15672 \
#   -d \
#   --name sensu-server \
#   $USER/sensu-server
#
# Either edit the config files under /config or mount them in yourself :)
#
# If you want to check logs, etc. Either mount them as a separate volume
# (ex. files /var/log/sensu/sensu-server.log, etc.
#
# To modify / install more plugins, see things a bit more closer, exec into it
# docker exec -it sensu-server bash
#
# TODO: 
# Split-off into multiple services (use Docker compose)
# Easier way of mounting config files / volumes
# Why the FUCK that supervisor complains about everything I do not know.

FROM centos:centos6

MAINTAINER Charlie Drage <charlie@charliedrage.com>

#! Basic packages
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum install -y passwd sudo git wget openssl which tar

#! Create the sensu user
RUN useradd sensu
RUN echo "sensu" | passwd sensu --stdin
RUN echo "sensu ALL=(ALL) ALL" >> /etc/sudoers.d/sensu

#! Install ruby
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable"
RUN /bin/bash -l -c "rvm install 2.1"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

#! Sensu server
ADD ./config/sensu.repo /etc/yum.repos.d/
RUN yum install -y sensu

#! Add config and checks
ADD ./config/config.json /etc/sensu/
ADD ./config/checks.json /etc/sensu/conf.d/

#! Add all handlers
RUN mkdir -p /etc/sensu/handlers
ADD ./config/handlers /etc/sensu/handlers/

#! Sensu dependancies / plugins
#RUN /bin/bash -l -c "/opt/sensu/embedded/bin/gem install sensu-plugin pony"

#! Uchiwa sensu control panel
RUN yum install -y uchiwa
ADD ./config/uchiwa.json /etc/sensu/

#! Supervisord
RUN yum install -y supervisor
ADD ./config/supervisord.conf /etc/supervisord.conf

#! Sensu, uchiwa, RabbitMQ ports + 80/8080/443 for mail/slacker communication
EXPOSE 587 3000 4567 5671 15672 2003 80 8080 443

CMD ["/usr/bin/supervisord"]
