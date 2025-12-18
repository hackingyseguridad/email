#!/bin/bash

postsuper -d ALL
# requiere tener instlado smarks
# simple script envia correo electronico de prueba con todas las verificaciones de seguridad suplantadas. ;) http://www.hackingyseguridad.com/
# @antonio_taboada 2025

send_email_swaks() {
    local from_email="notificaciones@movistar.es"
    local to_email="antonio.taboada@telefonica.net"

    echo "..."
    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --h-Subject "Prueba" \
          --h-From "Notificacion <$from_email>" \
          --h-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=movistar.es; s=selector1; t=$(date +%s)" \
          --h-Authentication-Results "mx.telefonica.es; spf=pass; dkim=pass; dmarc=pass" \
          --body "correo electronico de prueba con todas las verificaciones de seguridad pasadas. ;) http://www.hackingyseguridad.com/" \
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

