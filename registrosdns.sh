###############################################
# Extrae datos de las verificaciones en dominio
# ver registros MX y TXT tipos: SPF, DKIN, DMARK
# (r) hackingyseguridad.com  2025
# @antonio_taboada
###############################################
echo
echo "==========================================="
echo "muestra los registros MX, SPF, DKIN, DMARK"
echo "Uso ./registrosdns.sh <dominio.com> "
echo "=========================================="
echo

dig +short MX $1
dig +short TXT $1 | grep "v=spf1"
dig +short TXT $1 | grep  "dkim"
dig +short TXT $1 | grep  "dmarc"
