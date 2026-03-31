FROM maven:3.9.12-eclipse-temurin-17-alpine AS build
ADD . /app
WORKDIR /app  
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17.0.18_8-jdk-noble AS Runtime 
LABEL myproject=java
LABEL author=devopsteam 
ARG username=spc 
ENV JAVA_HOME=/usr/lib/jvm/
RUN useradd -m -d /usr/share/aws -s /bin/bash ${username}
USER ${username} 
WORKDIR /usr/share/aws
COPY --from=build /app/target/*.jar laxmikanth.jar 
EXPOSE 8080
CMD ["java", "-jar", "laxmikanth.jar"]
