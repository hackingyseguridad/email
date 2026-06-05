#!/bin/sh
#################################################
# simple script en Bash Shell, paara escanear
# con nmap servidores de correo electronico
# 2026 http://www.hackingyseguridad.com/
#################################################

echo "... "
nmap  -Pn -iL ip.txt --open -p 25,587,465,110,143,995,993 -O -sVC --script "pop3*,smtp*,imap*" -oG resultado.txt -oG resultado.csv -oX resultado.xml


