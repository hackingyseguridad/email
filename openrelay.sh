#!/bin/sh
# 
# http://www.hackingyseguridad.com 2025
# Antonio Taboada - simple comando para escanear y detectar servicdores de correo abiertos, sin requerir autenticación, open relay
#
echo "
echo "Detecta servidores de correo salientes, abiertos, sin restringir usuario, ni IP"
echo "
nmap -Pn $1 $2 $3 -sVC -p 25,587,465,2525,25025 --script smtp-open-relay 
