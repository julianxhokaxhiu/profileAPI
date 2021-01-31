FROM gradle:jdk11

COPY ./ /opt/

WORKDIR /opt

RUN gradle microBundle

###############################################################################

FROM openjdk:11

COPY --from=0 /opt/build/libs/ROOT-microbundle.jar /opt/application.jar

EXPOSE 8080

CMD java -jar /opt/application.jar
