# Stage 1: Build the React.js frontend
FROM node:14 as frontend-builder

WORKDIR /app

COPY frontend/package.json frontend/package-lock.json ./
RUN npm install

COPY frontend ./
RUN npm run build

# Stage 2: Build the Spring Boot backend
FROM maven:3.8.4-jdk-11 AS backend-builder

WORKDIR /app

COPY pom.xml .
COPY backend/src ./src

RUN mvn clean package -DskipTests

# Stage 3: Final image with both frontend and backend
FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=backend-builder /app/target/backend.jar ./
COPY --from=frontend-builder /app/build ./src/main/resources/static

EXPOSE 8080

CMD ["java", "-jar", "backend.jar"]

