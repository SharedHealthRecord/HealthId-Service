FROM centos

RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN  yum install java-1.8.0-openjdk -y


COPY healthId-api/build/distributions/healthId-*.noarch.rpm /tmp/healthId.rpm
RUN yum install -y /tmp/healthId.rpm && rm -f /tmp/healthId.rpm && yum clean all
COPY env/docker_healthid /etc/default/healthid
ENTRYPOINT . /etc/default/healthid && java -jar /opt/healthid/lib/healthId-schema-*.jar && java -Dserver.port=$HEALTH_ID_SERVICE_PORT -DHID_LOG_LEVEL=$HID_LOG_LEVEL -jar  /opt/healthid/lib/healthId-api.war

