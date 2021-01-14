FROM postgres
COPY init.sql /docker-entrypoint-initdb.d/

FROM ubuntu:focal

ADD run.sh /run.sh
ADD preconfig.sh /preconfig.sh
ADD gvm-openvas-docker-setup.sh /gvm-openvas-docker-setup.sh
ADD root-openvas-docker-setup.sh /root-openvas-docker-setup.sh
ADD postconfig.sh /postconfig.sh
ADD gvmuser.sh /gvmuser.sh

RUN /gvmuser.sh
RUN /preconfig.sh && su - gvm -c "/gvm-openvas-docker-setup.sh" && /root-openvas-docker-setup.sh && /postconfig.sh

CMD su - gvm -c "/run.sh"
EXPOSE 443
