#!/bin/sh

#############################################################
# simpla prueba desde localhost de
# envio sumple desde consola lina de comando conLinux Debian
# Uso.: $ ./envioconsola.sh antonio.taboada@telefonica.net
# http://www.hackingyseguridad.com/
############################################################

echo " Mensaje del correo electronico " | mail -s "Asunto del correo electronico " $your_email_address
