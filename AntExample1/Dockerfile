#base image
FROM alpine:latest

#Author
MAINTAINER hasithal<hasithalakmal684@gmail.com>

########################
#Install Oracle jdk 8
########################

ARG JAVA_DISTRIBUTION=jdk
ARG JAVA_MAJOR_VERSION=8
ARG JAVA_UPDATE_VERSION=121
ARG JAVA_BUILD_NUMBER=13
ARG JAVA_HASH=e9e7ea248e2c4826b92b3f075a80e441
ARG GLIBC_VERSION=2.25-r0
ARG BUILD_DATE=undefined

ENV LANG en_US.UTF-8
ENV JAVA_VERSION=1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
ENV JAVA_HOME=/opt/java/${JAVA_DISTRIBUTION}${JAVA_VERSION}
ENV PATH=$PATH:$JAVA_HOME/bin

RUN export JAVA_TARBALL=${JAVA_DISTRIBUTION}-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz && \
    if  [ -n "${JAVA_HASH}" ]; \
      then JAVA_HASH_EXTENTION='/'$JAVA_HASH'/' ; \
      else JAVA_HASH_EXTENTION= ; \
    fi && \
    # Install tooling
    apk add --update \
      ca-certificates \
      wget && \
    echo "Install latest glibc" && \
    wget --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    wget --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk && \
    apk add --allow-untrusted /tmp/glibc-bin-${GLIBC_VERSION}.apk && \
    wget --directory-prefix=/tmp https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-i18n-${GLIBC_VERSION}.apk && \
    apk --allow-untrusted add /tmp/glibc-i18n-${GLIBC_VERSION}.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    echo "Install oracle java" && \
    wget --directory-prefix=/tmp \
         --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}${JAVA_HASH_EXTENTION}/${JAVA_TARBALL} && \
    mkdir -p /opt/java && \
    tar -xzf /tmp/${JAVA_TARBALL} -C /opt/java/ && \
    if  [ "${JAVA_DISTRIBUTION}" = "server-jre" ]; \
      then mv /opt/java/jdk${JAVA_VERSION} ${JAVA_HOME} ; \
    fi && \
    ln -s ${JAVA_HOME}/bin/java /usr/bin/java && \
    # Remove obsolete packages
    apk del \
      ca-certificates \
      wget && \
    # Clean caches and tmps
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    rm -rf /var/log/*
	
#############################
#Install tomcat8
#############################

#add openssl for https download
RUN apk add --update openssl && \
    rm -rf /var/cache/apk/* /tmp/*

# set version info for desired tomcat version
ENV TC_MAJOR 8
ENV TC_VERSION 8.0.42

# calculate download url
ENV TC_URL https://www.apache.org/dist/tomcat/tomcat-$TC_MAJOR/v$TC_VERSION/bin/apache-tomcat-$TC_VERSION.tar.gz

# download and verify tomcat
WORKDIR /opt
RUN wget $TC_URL && \
	wget $TC_URL.sha1 && \
	sha1sum -cw apache-tomcat-$TC_VERSION.tar.gz.sha1

# install tomcat to /opt/apache-tomcat
RUN	tar -xzf apache-tomcat-$TC_VERSION.tar.gz && \
	mv apache-tomcat-$TC_VERSION apache-tomcat

# remove unnecessary components
RUN	rm -f apache-tomcat/bin/*.bat && \
	rm -rf apache-tomcat/webapps/docs && \
	rm -rf apache-tomcat/webapps/examples && \
	rm -f apache-tomcat-$TC_VERSION.*

#improve tomcat startup performance by setting non blocking random generator
RUN echo "CATALINA_OPTS=-Djava.security.egd=file:/dev/./urandom" > apache-tomcat/bin/setenv.sh && \
	chmod a+x apache-tomcat/bin/setenv.sh

WORKDIR /opt/apache-tomcat

#add war file to web apps
COPY AntExample.war /opt/apache-tomcat/webapps

# add volume for webapps folder
VOLUME /opt/apache-tomcat/webapps

# expose http and jmx ports
EXPOSE 8080 8009

# run tomcat by default
CMD ["/opt/apache-tomcat/bin/catalina.sh", "run"]









