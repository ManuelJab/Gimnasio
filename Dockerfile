# Etapa de construcción (Build)
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
# Copiamos primero el archivo de dependencias para aprovechar la caché de Docker
COPY pom.xml .
# Descargamos las dependencias del proyecto
RUN mvn dependency:go-offline -B
# Copiamos el código fuente
COPY src ./src
# Compilamos y empaquetamos la aplicación, omitiendo los tests
RUN mvn clean package -DskipTests

# Etapa de ejecución (Run)
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
# Copiamos el JAR generado desde la etapa de construcción
COPY --from=build /app/target/*.jar app.jar
# Exponemos el puerto de la aplicación
EXPOSE 8080
# Punto de entrada para ejecutar la aplicación
ENTRYPOINT ["java", "-jar", "app.jar"]
