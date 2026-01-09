#!/bin/sh
##################################################
# Prueba de concepto POC, envio bash shell gmail
# (R) hackingyseguridad.com 2026
# @antonio_taboada
################################################

sender="antonio.taboada@gmail.com"
receiver="antonio.taboada@telefonica.net"
gapp="satk lnxi lpti vavw"
sub="prueba de envio"

body="hola!!, prueba de envio .. mas info en https://github.com/hackingyseguridad/email   "

# Usa un archivo temporal para el contenido del correo
tempfile=$(mktemp)
echo -e "From: $sender\nTo: $receiver\nSubject: $sub\n\n$body" > "$tempfile"

# Enviando correo usando curl
response=$(curl -v --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from "$sender" \
    --mail-rcpt "$receiver" \
    --user "$sender:$gapp" \
    -T "$tempfile")

if [ $? -eq 0 ]; then
    echo "enviado ...!"
else
    echo "error ...!"
    echo "Respuesta: $response"
fi
