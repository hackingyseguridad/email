#!/bin/bash

# Prueba envio y spoof con lista multiple en fichero dominios.txt
# colocar un fichero con listado de dominios a probar en la misma capertaq del scropt
# enviara cada 10 segundos un email notificacion@dominio
# requiere swaks
# (r) hackingyseguridad.com 2025
# @antonio_taboada

# elimina cola de correos en servidor SMTP Postfix
postsuper -d ALL
#Inicia el envio: 
send_email_swaks() {
    local dominio="$1"
    local from_email="notificacion@$dominio"
    local to_email="antonio.taboada@telefonica.net"
    local message_id="<$(date +%s%N | sha256sum | cut -c1-32)@$dominio>"
    echo "========================================"
    echo "Enviando correo de prueba a $to_email..."
    echo "Remitente: $from_email"
    echo "Dominio: $dominio"
    echo "========================================"
    swaks --to "$to_email" \
          --from "$from_email" \
          --server localhost \
          --port 25 \
          --h-Subject "Prueba de entrega desde $dominio   !!! " \
          --h-From "Notificaciones <$from_email>" \
          --h-Message-ID "$message_id" \
          --h-Date "$(date -R)" \
          --body "Este es un correo electrónico de prueba simple.\n\nDominio de origen: $dominio\n\nPuedes ver mas información en:  https://github.com/hackingyseguridad/email/   " \
          --add-header "X-Priority: 3" \
          --add-header "Importance: normal" \
          --add-header "X-Domain: $dominio"
    sleep 3
}
contador=0
while IFS= read -r dominio || [[ -n "$dominio" ]]; do
    # Eliminar espacios en blanco al inicio y final
    dominio=$(echo "$dominio" | xargs)
    # Saltar líneas vacías
    if [ -z "$dominio" ]; then
        continue
    fi
    # Saltar comentarios (líneas que empiezan con #)
    if [[ "$dominio" =~ ^#.* ]]; then
        continue
    fi
    # Enviar correo con este dominio
    send_email_swaks "$dominio"
    # Incrementar contador
    ((contador++))

postqueue -f
sleep 3
mailq
sleep 2
mailq
sleep 2
postsuper -d ALL

done < "dominios.txt"
