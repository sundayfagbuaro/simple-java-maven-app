FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/my-app-1.0-SNAPSHOT.jar
ADD  ${JAR_FILE}  app.jar 
EXPOSE 80
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]