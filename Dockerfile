# ETAPA 1: Construcción con Maven
FROM maven:3.9.6-eclipse-temurin-17 AS build
COPY . .
RUN mvn clean package

# ETAPA 2: Ejecución con Tomcat
FROM tomcat:10.1-jdk17-temurin

# Borramos las apps por defecto de Tomcat para que tu web sea la principal
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiamos el archivo .war generado por Maven a la carpeta de Tomcat
# Maven genera el nombre basándose en el pom.xml. Normalmente es el nombre del proyecto.
COPY --from=build /target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
