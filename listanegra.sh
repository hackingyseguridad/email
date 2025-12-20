
#!/bin/sh
# Script simple para verificar IP puública en spamhaus

# nuesta IP publica!
IP=$(curl -s --max-time 5 ifconfig.me 2>/dev/null)
echo "Verificando IP: $IP"
echo "------------------------"
# resolucion IP inversa para consultas DNS
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
echo "https://check.spamhaus.org/query/ip/$IP"

