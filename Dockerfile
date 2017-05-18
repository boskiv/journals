# First stage to build the application
FROM maven:3.5.0-jdk-8-alpine AS build-env
ADD ./pom.xml pom.xml
ADD ./src src/
RUN mvn clean package -DskipTests

# Final stage to define our minimal runtime
FROM openjdk:8-jre
COPY --from=build-env target/*.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=container","-jar","/app.jar"]