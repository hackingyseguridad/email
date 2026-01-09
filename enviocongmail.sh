#!/bin/sh
##################################################
# Prueba simple de envio en bash shell con gmail
# (R) hackingyseguridad.com 2026
# antonio_taboada
################################################

sender="antonio.taboada@gmail.com"
receiver="antonio.taboada@telefonica.net"
gapp="satk lnxi lpti vav"
sub="prueba de envio"
body="hola!!, prueba de envio .. mas info en https://github.com/hackingyseguridad/email"

# Display name para el remitente ,puedes modificarlo)!"display-name" y poner un nombre real o suplantado para mostrar y cuenta email <suplantada@suplantado.com> 
display_name="notificaciones <notificaciones@google.com> "
#  AQUI es donde simumulamos suplantacion

curl -v --url 'smtps://smtp.gmail.com:465' --ssl-reqd \
    --mail-from "$sender" \
    --mail-rcpt "$receiver" \
    --user "$sender:$gapp" \
    --mail-rcpt-allowfails \
    -T- <<EOF
From: $display_name <$sender>
To: $receiver
Subject: $sub
Date: $(date -R)
Message-ID: <$(date +%s%N)@google.com>
X-Google-Notification: 1
X-Priority: 1

$body
EOF

if [ $? -eq 0 ]; then
    echo "enviado ...!"
else
    echo "error ...!"
fi

