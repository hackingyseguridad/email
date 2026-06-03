#!/bin/sh
#################################################
# simple script en Bash Shell, paara escanear
# con nmap servidores de correo electronico
# http://www.hackingyseguridad.com/
#################################################

echo "... "
nmap  -Pn -iL ip.txt --open -p 25,587,465,110,143,995,993 -sVC  --script "pop3-capabilities or pop3-ntlm-info" -oG resultado.txt -oG resultado.csv -oX resultado.xml


