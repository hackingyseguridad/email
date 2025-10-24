#################################################
# simple script en Bash Shell, paara escanear
# con nmap servidores de correo electronico
# http://www.hackingyseguridad.com/
#################################################

#!/bin/sh
nmap  -Pn -iL ip.txt --open -n --randomize-hosts --max-retries 1   -p 25,587,465,110,143,995,993 --script "pop3-capabilities or pop3-ntlm-info" -oG resultado2.txt 


