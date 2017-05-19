# First stage to build the application
FROM maven:3.5.0-jdk-8-alpine AS build-env
ADD ./pom.xml pom.xml
ADD ./src src/
RUN mvn clean package -DskipTests

# Final stage to define our minimal runtime
FROM openjdk:8-jre
ADD ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
COPY --from=build-env target/*.jar app.jar
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +x /wait-for-it.sh
ENTRYPOINT ["/docker-entrypoint.sh"]