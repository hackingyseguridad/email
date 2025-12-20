#!/bin/sh
# Script simple para verificar IP pública en Spamhaus

# nuesta IP pública actual 
IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)

if [ -z "$IP" ]; then
    IP=$(curl -s --max-time 5 icanhazip.com 2>/dev/null)
fi

if [ -z "$IP" ]; then
    echo "ERROR: No se puede obtener IP pública"
    exit 1
fi

echo "Verificando IP: $IP"
echo "------------------------"

# Reversar IP para consulta DNS
REV_IP=$(echo "$IP" | awk -F. '{print $4"."$3"."$2"."$1}')

# Consultar listas principales
for LIST in zen.spamhaus.org sbl.spamhaus.org xbl.spamhaus.org pbl.spamhaus.org; do
    if host "$REV_IP.$LIST" 2>/dev/null | grep -q "has address"; then
        echo "❌ LISTADA en $LIST"
        host "$REV_IP.$LIST" | grep "has address"
    else
        echo "✓ OK en $LIST"
    fi
done

echo "------------------------"
echo "Para más detalles visita:"
echo "https://check.spamhaus.org/query/ip/$IP"
