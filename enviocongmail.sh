#!/bin/sh
#####################################################
# Prueba simple de envio con gmail en bash con swaks
# (R) hackingyseguridad.com 2026
# antonio_taboada
#####################################################
#!/bin/sh
real_sender="antonio.taboada@gmail.com"
gapp_password="satk lnxi lpti vav"
to_email="antonio.taboada@telefonica.net"
subject="Asunto del email"
body="Texo del correo "
swaks \
    --to "$to_email" \
    --from "$real_sender" \
    --server smtp.gmail.com:587 \
    --auth LOGIN \
    --auth-user "$real_sender" \
    --auth-password "$gapp_password" \
    --tls \
    --h-Subject: "$subject" \
    --body "$body"
