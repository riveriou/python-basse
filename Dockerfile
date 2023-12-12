FROM ubuntu:22.04
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

ENV ACCEPT_EULA Y
ENV MSSQL_PAID standard
ENV MSSQL_SA_PASSWORD !Qazxsw2
ENV MSSQL_TCP_PORT 1433
ENV NOTVISIBLE "in users profile"

RUN ln -snf /usr/share/zoneinfo/Asia/Taipei /etc/localtime && echo Asia/Taipei > /etc/timezone

RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install -y curl wget vim nano lsof net-tools dialog software-properties-common less unzip gpg-agent less unzip apt-utils
RUN apt-get install -y openssh-server supervisor python3 python3-pip
#RUN apt-get install -y libldap-2.4-2 locales

WORKDIR /data
ADD . /data
RUN chmod 755 /data/*

RUN /data/flask.sh
RUN /data/sshd.sh
RUN /data/mssql.sh

RUN rm -r /data/*.sh

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

#RUN echo "[program:python-flask]" >> /etc/supervisor/conf.d/supervisord.conf
#RUN echo 'command=python3 /data/app.py' >> /etc/supervisor/conf.d/supervisord.conf

#RUN echo "[program:sshd]" >> /etc/supervisor/conf.d/supervisord.conf
#RUN echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/conf.d/supervisord.conf

RUN echo '#!/bin/sh' >> /startup.sh
RUN echo '/opt/mssql/bin/sqlservr' >> /startup.sh
RUN echo '/usr/sbin/sshd -D' >> /startup.sh
RUN echo 'python3 /data/app.py' >> /startup.sh

RUN echo 'exec supervisord -c /etc/supervisor/supervisord.conf' >> /startup.sh

RUN chmod +x /startup.sh

EXPOSE  22
EXPOSE  8000
CMD ["/startup.sh"]
