#!/bin/sh
# suplanta email google.com desde SMTP en localhost 

HOST="localhost"
PORT="25"

send_email() {
    local from_email="notifications@google.com"
    local to_email="antonio.taboada@telefonica.net"
    
    echo "Enviando email de $from_email a $to_email"
    
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
        echo "Si recibes este email, el sistema está funcionando correctamente."
        echo ""
        echo "Saludos,"
        echo "El equipo técnico"
        echo "."
        sleep 2
        echo "QUIT"
    ) | telnet $HOST $PORT 2>&1 | grep -E "^(250|354|220|221)"
    
    echo "Envío completado"
}

# Ejecutar
send_email
# Opcional: ejecutar versión avanzada
# send_email_advanced

# Opcional: probar servidores SMTP
# test_smtp_servers
