#!/bin/bash

# Script envío

HOST="localhost"
PORT="25"

send_email() {
    local from_email="notificaciones@google.com"
    local to_email="antonio.taboada@gmail.com"

    echo "enviando email de $from_email a $to_email"

    (
        echo "EHLO google.com"
        sleep 2
        echo "MAIL FROM: <$from_email>"
        sleep 2
        echo "RCPT TO: <$to_email>"
        sleep 2
        echo "DATA"
        sleep 2
        echo "From: $from_email"
        echo "To: $to_email"
        echo "Subject: Email de Prueba del Sistema"
        echo "Date: $(date -R)"
        echo ""
        echo "Este es un mensaje de prueba enviado mediante SMTP directo."
        echo "Si recibes este email, algo esta funcionando mal en la verificaciones  "
        echo "Saludos,"
        echo "http://www.hackingyseguridad.com/"
        echo "."
        sleep 2
        echo "QUIT"
    ) | telnet $HOST $PORT 2>&1 | grep -E "^(250|354|220|221)"

    echo "..."
}

# Ejecutar
send_email
echo
mailq
postqueue -f
echo
echo "borra la cola de envio .."
echo
echo "postsuper -d ALL "
echo
echo ".."
echo "..."
echo

