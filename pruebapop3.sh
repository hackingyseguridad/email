#!/bin/sh

echo
echo "Prueba manual de email en servidor POP3"
echo "Introduce el usuario EMAIL a probar (ej: antonio.taboada@hackingyseguridad.com): "
echo 

read USUARIO

(
    sleep 1
    echo "USER $USUARIO"
    sleep 1
    echo "QUIT"
    sleep 1
) | telnet pop3.dominio.com 110

