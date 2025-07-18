##########################################
#  Genera certificados 
#  http://www.hackingyseguridad.com/ 
#########################################

#!/bin/sh

# Genera autocertificados digital, en instala - se requiere OpenSSL
sudo apt-get install openssl

# Generar formato PEM fichero con clave privada MyRootCA.key
openssl genrsa -out MyRootCA.key 2048

# Generar a partir de la clave privada en MyRootCA el fichero con clave publica MyRootCA.pem
openssl req -x509 -new -nodes -key MyRootCA.key -sha256 -days 1024 -out MyRootCA.pem

# Convertir MyRootCA.pem en MyRootCA.crt para Windows
openssl x509 -outform der -in MyRootCA.pem -out MyRootCA.crt

# Convertir MyRootCA.pem en MyRootCA.der
openssl x509 -outform der -in MyRootCA.pem -out MyRootCA.der

# Copiamos los autocertificados generados en las capertas repositorio de certificados habituales en SO Linux Debian

cp MyRootCA.key /etc/ssl/private/
cp MyRootCA.pem /etc/ssl/certs/
cp MyRootCA.crt /etc/ssl/certs/
cp MyRootCA.der /etc/ssl/certs/ 

echo "..."
