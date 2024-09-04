
Puertos TCP:

***SMTP*** Simple Mail Trasport Protocol: 25, 587 y 465 con SSL/TLS, 2525, 25025

***POP3*** 






# envio email desde consola linux

echo "This is the body of the email" | mail -s "This is the subject line" your_email_address


# Registros de seguridad:


***SPF***, (Sender Policy Framework) es un tipo de resgistro en DNS autoritativo del dominio, donde se especifica los hostname o IP de los servidores de correo saliente, SMTP autorizados.

***DKIN***, (DomainKeys Identified Mail) protocolo de identidad, integridad que inserta firma cifrada en la cabecera del email, que certifica al destinatario que es veridico.

***DMARK***,  (Domain-based Message Authentication, Reporting, and Conformance) es una política de correo electrónico que combina, tiene en cuenta SPF y DKIN, para confirmar la legitimidad del dominio en el origen FROM del email
