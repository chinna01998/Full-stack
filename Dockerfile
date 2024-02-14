# Stage 1: Build the React.js frontend
#FROM node:14 as frontend-builder

#WORKDIR /app

#COPY react-frontend/package.json react-frontend/package-lock.json ./
#RUN npm install

#COPY react-frontend ./
#RUN npm run build

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
#COPY --from=frontend-builder /app/build ./src/main/resources/static

#Stage 4 Use the official MySQL image from Docker Hub
FROM mysql:8.0 AS database

# Set environment variables for MySQL root password and database name
ENV MYSQL_ROOT_PASSWORD=root_password
ENV MYSQL_DATABASE=my_database

# Set working directory for MySQL
WORKDIR /docker-entrypoint-initdb.d

# Copy SQL script to initialize the database
COPY init.sql .

# Use adoptopenjdk/openjdk17 as the base image for the final image
EXPOSE 8080

CMD ["java", "-jar", "backend.jar"]

