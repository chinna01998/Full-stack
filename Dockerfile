# Stage 2: Build the Spring Boot backend
FROM maven:3.8.5-openjdk-17 AS backend-builder

WORKDIR /app

COPY springboot-backend/pom.xml .
COPY springboot-backend/src ./src

RUN mvn clean package -DskipTests

# Stage 3: Final image with both frontend and backend
FROM openjdk:17.0-jdk

WORKDIR /app

COPY --from=backend-builder /app/target/springboot*.jar ./backend.jar

EXPOSE 8080

CMD ["java", "-jar", "backend.jar"] 
