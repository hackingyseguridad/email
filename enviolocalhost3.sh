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
        sleep 1
        echo "MAIL FROM: <$from_email>"
        sleep 1
        echo "RCPT TO: <$to_email>"
        sleep 1
        echo "DATA"
        sleep 1

        # Cabeceras personalizadas para evitar filtros
        echo "From: $from_email"
        echo "To: $to_email"
        echo "Subject: Notificación del Sistema"
        echo "Date: $(date -R)"
        echo "Message-ID: <$(date +%s)@google.com>"
        echo "X-Priority: 3"
        echo "X-Mailer: Microsoft Outlook 16.0"
        echo "X-Originating-IP: 192.168.1.1"
        echo "Return-Path: <$from_email>"
        echo "Received: from google.com ([66.249.66.1]) by mx.google.com with ESMTP id $(date +%s)"
        echo "MIME-Version: 1.0"
        echo "Content-Type: text/plain; charset=\"utf-8\""
        echo "Content-Transfer-Encoding: 7bit"
        echo ""

        # Cuerpo del mensaje
        echo "Estimado usuario,"
        echo ""
        echo "Este es un mensaje automático del sistema de notificaciones."
        echo "Si recibes este email, el sistema está funcionando correctamente."
        echo ""
        echo "Para cualquier consulta, no responda a este mensaje."
        echo ""
        echo "Atentamente,"
        echo "El equipo de soporte técnico"
        echo "."
        sleep 1
        echo "QUIT"
    ) | telnet $HOST $PORT 2>&1 | grep -E "^(250|354|220|221|235)"

    echo "Proceso completado."
}

# Función alternativa con diferentes técnicas
send_email_advanced() {
    local from_domain="gmail.com"
    local from_user="notificaciones"
    local from_email="$from_user@$from_domain"
    local to_email="antonio.taboada@telefonica.net"
    local smtp_server="$HOST"

    echo "Enviando email avanzado de $from_email a $to_email"

    (
        echo "EHLO $from_domain"
        sleep 1
        echo "MAIL FROM: <$from_email>"
        sleep 1
        echo "RCPT TO: <$to_email>"
        sleep 1
        echo "DATA"
        sleep 1

        # Cabeceras mejoradas para eludir filtros
        echo "From: \"Sistema de Notificaciones\" <$from_email>"
        echo "To: $to_email"
        echo "Subject: Actualización del Sistema - $(date +%Y%m%d)"
        echo "Date: $(date -R)"
        echo "Message-ID: <$(uuidgen 2>/dev/null || date +%s)@$from_domain>"
        echo "X-Mailer: Mozilla Thunderbird"
        echo "X-Originating-IP: 8.8.8.8"
        echo "X-Auth: none"
        echo "Precedence: bulk"
        echo "Auto-Submitted: auto-generated"
        echo "List-Unsubscribe: <mailto:unsubscribe@$from_domain>"
        echo "DKIM-Signature: v=1; a=rsa-sha256; d=$from_domain; s=google;"
        echo "MIME-Version: 1.0"
        echo "Content-Type: text/plain; charset=ISO-8859-1"
        echo "Content-Transfer-Encoding: quoted-printable"
        echo ""

        # Contenido más natural
        echo "Hola,"
        echo ""
        echo "Este es un mensaje automático de confirmación del sistema."
        echo "El proceso se ha completado exitosamente."
        echo ""
        echo "No es necesario responder a este mensaje."
        echo ""
        echo "Saludos cordiales,"
        echo "Equipo de Sistemas"
        echo "."
        sleep 1
        echo "QUIT"
    ) | telnet $smtp_server $PORT 2>&1
}

# Función para probar diferentes servidores SMTP
test_smtp_servers() {
    local servers="localhost 127.0.0.1 smtp smtp.localhost"
    local from_email="test@example.com"
    local to_email="antonio.taboada@telefonica.net"

    for server in $servers; do
        echo "Probando servidor: $server"
        (
            echo "EHLO example.com"
            sleep 1
            echo "MAIL FROM: <$from_email>"
            sleep 1
            echo "RCPT TO: <$to_email>"
            sleep 1
            echo "QUIT"
        ) | telnet $server $PORT 2>&1 | grep -E "^(250|220|221)" && echo "✅ $server funciona" || echo "❌ $server falló"
        echo "---"
    done
}

# Ejecutar función principal
send_email

# Opcional: ejecutar versión avanzada
# send_email_advanced

# Opcional: probar servidores SMTP
# test_smtp_servers
