# Use official base image of Java Runtime
FROM maven:eclipse-temurin as packager
WORKDIR /home/app
COPY pom.xml .
RUN mvn dependency:resolve

FROM packager as builder
COPY . .
RUN mvn install -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /home/app
COPY --from=builder /home/app/target/*.jar .
ENV SPRING_OUTPUT_ANSI_ENABLED=always
ENTRYPOINT java -jar ./*.jar