#!/bin/bash
echo
echo "Detecta servidores de correo salientes, abiertos, sin restringir usuario, ni IP"
nmap -Pn $1 -p 25,587,465,2525 --script smtp-open-relay
