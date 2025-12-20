#/bin/sh
# configuracion probada para envio sumple desde localhost
# configuracion solo para SMPT con Postfix en localhost
# hackingyseguridad.com
# @antonio_taboada

chmod 777 *

echo
echo "Aplicar configuracion Postfix para envio por SMTP en localhost ?"
echo "caso contrario Ctrol C"
echo
sleep 9

cp postfix_conf_localhost.txt /etc/postfix/main.cf

service postfix restart
echo
echo "..."
echo
