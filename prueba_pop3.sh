#!/bin/bash

# Script de diagnóstico para conexión POP3
POP3_SERVER="1.1.1.1"
USERNAME="antonio.taboada@hackingyseguridad.com"

echo "=== DIAGNÓSTICO POP3 COMPLETO ==="
echo "Servidor: $POP3_SERVER"
echo "Usuario: $USERNAME"
echo

# 1. Verificar conectividad básica
echo "1. Verificando conectividad al servidor..."
if ping -c 2 -W 3 "$POP3_SERVER" &> /dev/null; then
    echo "   ✅ Servidor responde a ping"
else
    echo "   ❌ Servidor NO responde a ping"
fi

# 2. Verificar puerto POP3 (110)
echo "2. Verificando puerto POP3 (110)..."
if nc -z -w 3 "$POP3_SERVER" 110 &> /dev/null; then
    echo "   ✅ Puerto 110 está abierto"
else
    echo "   ❌ Puerto 110 está cerrado o bloqueado"
fi

# 3. Verificar puerto POP3S (995) por si acaso
echo "3. Verificando puerto POP3S (995)..."
if nc -z -w 3 "$POP3_SERVER" 995 &> /dev/null; then
    echo "   ✅ Puerto 995 (POP3S) está abierto"
else
    echo "   ❌ Puerto 995 (POP3S) está cerrado"
fi

# 4. Solicitar contraseña
echo
stty -echo
printf "4. Contraseña para $USERNAME: "
read PASSWORD
stty echo
echo

# 5. Intentar conexión manual simple
echo "5. Intentando conexión manual al puerto 110..."
{
    sleep 2
    echo "USER $USERNAME"
    sleep 1
    echo "PASS $PASSWORD"
    sleep 1
    echo "QUIT"
} | timeout 10 telnet "$POP3_SERVER" 110 2>&1 | head -20

echo
echo "----------------------------------------"

# 6. Intentar con netcat de manera más verbosa
echo "6. Intentando con netcat de manera verbosa..."
echo "Comandos a enviar:"
echo "USER $USERNAME"
echo "PASS [password]"
echo "QUIT"
echo

# Crear archivo temporal con comandos
CMD_FILE=$(mktemp)
cat > "$CMD_FILE" << EOF
USER $USERNAME
PASS $PASSWORD
QUIT
EOF

echo "Iniciando conexión netcat..."
timeout 10 nc -v "$POP3_SERVER" 110 < "$CMD_FILE" 2>&1
NC_EXIT=$?

rm -f "$CMD_FILE"

echo
echo "----------------------------------------"
echo "RESULTADO DEL DIAGNÓSTICO:"

if [ $NC_EXIT -eq 0 ]; then
    echo "✅ Netcat se conectó exitosamente"
elif [ $NC_EXIT -eq 124 ]; then
    echo "⏱️  Timeout en la conexión"
elif [ $NC_EXIT -eq 1 ]; then
    echo "❌ Error de conexión - Servidor no accesible"
else
    echo "⚠️  Error desconocido (Código: $NC_EXIT)"
fi

# 7. Verificar si necesitamos SSL
echo
echo "7. Probando con SSL (openssl)..."
if command -v openssl &> /dev/null; then
    timeout 10 openssl s_client -connect "$POP3_SERVER":995 -quiet < /dev/null 2>&1 | head -10
else
    echo "   Openssl no disponible"
fi
