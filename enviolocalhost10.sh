#!/bin/bash

# Eliminar cola de correos en servidor SMTP  Postfix
postsuper -d ALL
# requiere smarks
# (r) hackingyseguridad.com 2025
# @antonio_taboada



send_email_swaks() {
    # ⚠️ CAMBIA ESTO: Usa un dominio que controles
    local from_email="notificaciones@google.com"
    local to_email="antonio.taboada@telefonica.net"

    # Generar Message-ID único
    local message_id="<$(date +%s%N | sha256sum | cut -c1-32)@${from_email##*@}>"

    echo "Enviando correo de prueba a $to_email..."

    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --port 25 \
          --h-Subject "Prueba de entrega" \
          --h-From "Notificaciones <$from_email>" \
          --h-Message-ID "$message_id" \
          --h-Date "$(date -R)" \
          --body "Este es un correo electrónico de prueba simple.\n\nPuedes ver más información en: http://www.hackingyseguridad.com/" \
          --add-header "X-Priority: 3" \
          --add-header "Importance: normal"
}

# Verificar que Postfix está corriendo
if ! systemctl is-active --quiet postfix; then
    echo "⚠️  Postfix no está activo. Intentando iniciar..."
    sudo systemctl start postfix
    sleep 2
fi

# Enviar el correo
send_email_swaks

echo ""
echo "Revisando cola de correo..."
postqueue -p

echo ""
echo "=== Últimos logs de Postfix ==="
if command -v journalctl &>/dev/null; then
    sudo journalctl -u postfix -n 10 --no-pager
else
    sudo tail -20 /var/log/mail.log 2>/dev/null || echo "No se encontraron logs"
fi
