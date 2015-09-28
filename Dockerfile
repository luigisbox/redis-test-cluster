FROM phusion/baseimage:0.9.16

MAINTAINER Luigis Box <support@luigisbox.com>

RUN add-apt-repository -y ppa:rwky/redis
RUN apt-get update -qq && apt-get install -qq redis-server

ADD nodes nodes

VOLUME /nodes/8000/data
VOLUME /nodes/8001/data
VOLUME /nodes/8002/data
VOLUME /nodes/8003/data
VOLUME /nodes/8004/data
VOLUME /nodes/8005/data

RUN mkdir -p /etc/service/redis-8000
RUN mkdir -p /etc/service/redis-8001
RUN mkdir -p /etc/service/redis-8002
RUN mkdir -p /etc/service/redis-8003
RUN mkdir -p /etc/service/redis-8004
RUN mkdir -p /etc/service/redis-8005

ADD /nodes/8000/start.sh /etc/service/redis-8000/run
ADD /nodes/8001/start.sh /etc/service/redis-8001/run
ADD /nodes/8002/start.sh /etc/service/redis-8002/run
ADD /nodes/8003/start.sh /etc/service/redis-8003/run
ADD /nodes/8004/start.sh /etc/service/redis-8004/run
ADD /nodes/8005/start.sh /etc/service/redis-8005/run

RUN apt-get install -qq ruby
RUN gem install redis --no-ri --no-rdoc
ADD bootstrap.sh /bootstrap.sh
ADD redis-trib.rb /redis-trib.rb

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN  /sbin/my_init -- /bootstrap.sh

CMD ["/sbin/my_init"]
