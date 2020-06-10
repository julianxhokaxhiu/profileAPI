FROM openjdk:11
COPY ROOT-microbundle.jar /opt/application.jar
EXPOSE 8080
CMD java -jar /opt/application.jar