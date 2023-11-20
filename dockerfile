# Usa una imagen base de Ubuntu
FROM ubuntu:latest

# Actualiza la lista de paquetes e instala Apache 2
RUN apt-get update && \
    apt-get install -y apache2 && \
   # apt-get install -y php && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expone el puerto 80 para que puedas acceder al servidor web desde el host
EXPOSE 80

# Inicia el servicio de Apache al iniciar el contenedor
CMD ["apache2ctl", "-D", "FOREGROUND"]

COPY glpi.sh /glpi.sh
RUN chmod +x /glpi.sh
RUN ./glpi.sh


