# email

echo "This is the body of the email" | mail -s "This is the subject line" your_email_address


# Registros de seguridad:


***SPF***, (Sender Policy Framework) es un tipo de resgistro en DNS autoritativo del dominio, donde se especifica los hostname o IP de los servidores de correo saliente, SMTP autorizados.

***DKIN***, inserta  firma cifrada en la cabecera del email, que certifica al destinatario que es veridico.

***DMARK***, tiene en cuenta SPF y DKIN, para confirmar la legitimidad del dominio en el origen FROM del email
