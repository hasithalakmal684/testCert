#base image
FROM 192.168.94.70/java8tomcat

#Author
MAINTAINER hasithal<hasithalakmal684@gmail.com>

#Add configuration files to tomcat
ADD context.xml /opt/apache-tomcat/conf/

#add war file to web apps
COPY ../workspace/bcare_5_4_1_int/dist/bcare_5_4_1_int.war /opt/apache-tomcat/webapps



# add volume for webapps folder
VOLUME /opt/apache-tomcat/webapps

# expose http and jmx ports
EXPOSE 8080 8009

# run tomcat by default
CMD ["/opt/apache-tomcat/bin/catalina.sh", "run"]

RUN echo "bcare_5_4_1_int application started and running..."