#!/bin/bash

# requiere smarks
# hackingyseguridad.com

send_email_swaks() {
    local from_email="notificaciones@movistar.es"
    local to_email="antonio.taboada@telefonica.net"

    echo "..."

    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --h-Subject "Prueba" \
          --h-From "Notificaciones Movistar <$from_email>" \
          --h-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=movistar.es; s=selector1; t=$(date +%s)" \
          --h-Authentication-Results "mx.telefonica.es; spf=pass; dkim=pass; dmarc=pass" \
          --body "Este es un mensaje de prueba con todas las verificaciones de seguridad pasadas." \
          --add-header "X-Priority: 1" \
          --add-header "Importance: high"
}

    send_email_swaks

mailq
