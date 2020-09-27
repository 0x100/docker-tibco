FROM debian:stable-slim

RUN mkdir -p /usr/share/man/man1
RUN apt-get update -y && \
    apt-get install bc wget unzip openjdk-11-jdk curl lib32z1 bc lib32ncurses6 lib32stdc++6 lib32z1 lib32z1-dev -y
RUN groupadd -r tibgrp -g 433 && \
	useradd -u 431 -r -m -g tibgrp -d /home/tibusr -s /bin/bash -c "TIBCO Docker image user" tibusr && \
	chown -R tibusr:tibgrp /home/tibusr && \
    mkdir /opt/tibco && \
    chown -R tibusr:tibgrp /opt/tibco && \
    mkdir /tmp/install && \
    chown -R tibusr:tibgrp /tmp/install

USER tibusr

ADD package/TIB_ems*_linux_x86_64.zip* /tmp/install/
RUN cd /tmp/install/ && cat TIB_ems*_linux_x86_64.zip* > TIB_ems_linux_x86_64.zip && \
    unzip /tmp/install/TIB_ems_linux_x86_64.zip -d /tmp/install/tibems/
RUN cd /tmp/install/tibems/TIB_ems* && \
    for f in tar/*; do tar -xvf $f; done && \
    mv opt/tibco/ems /opt/tibco

RUN rm -rf /tmp/install/

RUN mkdir -p /opt/tibco/ems/8.5/config
ADD config/*.conf /opt/tibco/ems/8.5/config/

RUN mkdir -p /tmp/tibco/ems/datastore

ENV TZ=Europe/Moscow
EXPOSE 7222
ENTRYPOINT ["/opt/tibco/ems/8.5/bin/tibemsd", "-config", "/opt/tibco/ems/8.5/config/tibemsd.conf"]