#!/bin/bash
echo
echo "Detecta servidores de correo salientes, abiertos, sin restringir usuario, ni IP"
nmap -Pn $1 $2 $3 -sVC -p 25,587,465,2525,25025 --script smtp-open-relay 
