#base image
FROM 192.168.94.70/192.168.94.70/java8tomcat:latest

#Author
MAINTAINER hasithal<hasithalakmal684@gmail.com>

#add war file to web apps
COPY AntExample.war /opt/apache-tomcat/webapps

# add volume for webapps folder
VOLUME /opt/apache-tomcat/webapps

# expose http and jmx ports
EXPOSE 8080 8009

# run tomcat by default
CMD ["/opt/apache-tomcat/bin/catalina.sh", "run"]

RUN echo "Docker Test Finished..."