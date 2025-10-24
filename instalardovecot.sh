# ###########################################
# Instalar pop3 en Kali Linux con dovecot
# htttp://www.hackingyseguridad.com
############################################

#!/bin/sh

apt-get install dovecot-pop3d -y
sudo systemctl restart dovecot
sudo systemctl enable dovecot
