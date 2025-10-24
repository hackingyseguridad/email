#########################################
# simpla prueba desde localhost de
# envio desde consola Linux Debian
# http://www.hackingyseguridad.com/
########################################

#!/bin/sh
echo "This is the body of the email" | mail -s "This is the subject line" $your_email_address
