#!/bin/sh
# Script para consultar registros MX y TXT de dominios
# Procesa dominios en el archivo: dominios.txt
# (r) hackingyseguridad.com 2025 @antonio_taboada

for dominio in $(cat dominios.txt); do
    dominio=$(echo $dominio | tr -d '[:space:]')
    echo
    echo "Consultando...: $dominio"
    echo
    host -t MX "$dominio"
    host -t TXT "$dominio" | grep "spf" || echo "No se encontraron registros SPF"
    host -t TXT "$dominio" | grep "dkim" || echo "No se encontraron registros DKIM"
    host -t TXT "$dominio" | grep "dmarc" || echo "No se encontraron registros DMARC"
done

echo "..."

