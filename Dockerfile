FROM ubuntu:22.04
MAINTAINER River riou

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

ENV PATH /usr/local/bin:$PATH
ENV GPG_KEY 7169605F62C751356D054A26A821E680E5FA6305
ENV PYTHON_VERSION 3.12.1
ENV PYTHON_PIP_VERSION 23.2.1
ENV PYTHON_GET_PIP_URL https://github.com/pypa/get-pip/raw/4cfa4081d27285bda1220a62a5ebf5b4bd749cdb/public/get-pip.py
ENV PYTHON_GET_PIP_SHA256 9cc01665956d22b3bf057ae8287b035827bfd895da235bcea200ab3b811790b6

ENV ACCEPT_EULA Y
ENV MSSQL_PID standard
ENV MSSQL_SA_PASSWORD sasa
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
#RUN /data/mssql.sh
#RUN /data/flask.sh
RUN /data/sshd.sh
#RUN /data/python.sh

RUN rm -r /data/*.sh

RUN echo "[supervisord] " >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "nodaemon=true" >> /etc/supervisor/conf.d/supervisord.conf
RUN echo "user=root" >> /etc/supervisor/conf.d/supervisord.conf

#RUN echo "[program:python-flask]" >> /etc/supervisor/conf.d/supervisord.conf
#RUN echo 'command=python3 /data/app.py' >> /etc/supervisor/conf.d/supervisord.conf

#RUN echo "[program:sshd]" >> /etc/supervisor/conf.d/supervisord.conf
#RUN echo 'command=/usr/sbin/sshd -D' >> /etc/supervisor/conf.d/supervisord.conf

RUN echo '#!/bin/sh' >> /startup.sh
#RUN echo '/opt/mssql/bin/sqlservr' >> /startup.sh
RUN echo '/usr/sbin/sshd -D' >> /startup.sh
RUN echo 'python3 /data/app.py' >> /startup.sh

RUN echo 'exec supervisord -c /etc/supervisor/supervisord.conf' >> /startup.sh

RUN chmod +x /startup.sh

EXPOSE  22
EXPOSE  8000
CMD ["/startup.sh"]
