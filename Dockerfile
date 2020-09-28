FROM centos:latest

MAINTAINER Ilya Lysenko <lysenko.ilya@gmail.com>

RUN mkdir -p /usr/share/man/man1
RUN yum upgrade -y && \
    yum install bc wget unzip openjdk-11-jdk curl lib32z1 bc lib32ncurses6 lib32stdc++6 lib32z1 lib32z1-dev -y
RUN groupadd -r tibgrp -g 433 && \
    useradd -u 431 -r -m -g tibgrp -d /home/tibusr -s /bin/bash -c "TIBCO Docker image user" tibusr && \
    chown -R tibusr:tibgrp /home/tibusr && \
    mkdir /opt/tibco && \
    chown -R tibusr:tibgrp /opt/tibco && \
    mkdir /tmp/install && \
    mkdir -p /tmp/tibco/ems/datastore && \
    chown -R tibusr:tibgrp /tmp/tibco/ems/datastore && \
    mkdir -p /opt/tibco/ems/config && \
    chown -R tibusr:tibgrp /opt/tibco/ems/config

ADD config/*.conf /opt/tibco/ems/config/
ADD package/TIB_ems*_linux_x86_64.zip* /tmp/install/

RUN cd /tmp/install/ && cat TIB_ems*_linux_x86_64.zip* > TIB_ems_linux_x86_64.zip && \
    unzip /tmp/install/TIB_ems_linux_x86_64.zip -d /tmp/install/tibems/
RUN cd /tmp/install/tibems/TIB_ems* && \
    yum install -y rpm/*.rpm
RUN rm -rf /tmp/install/

USER tibusr
ENV TZ=Europe/Moscow
EXPOSE 7222
ENTRYPOINT ["/opt/tibco/ems/8.5/bin/tibemsd", "-config", "/opt/tibco/ems/config/tibemsd.conf"]