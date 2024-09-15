# envio email con telnet

telnet smtp.hackingyseguridad.com 25

helo smtp.hackingyseguridad.com

starttls 

AUTH LOGIN

aGFja2luZ3lzZWd1cmlkYWRAaGFja2luZ3lzZWd1cmlkYWQuY29t

UGFzc3dvcmQwMQ==

MAIL FROM: <happyhacking@hackingandseguridad.com> 

RCPT TO: antonio.taboada@telefonica.net

data

Subject: HappyHacking

@antonio_taboada  - http://www.hackingyseguridad.com/ 

.

quit

QUIT

nc -v smtp.hackingyseguridad.com 25

mailq

postqueue -f

Borrar toda la cola

postsuper -d ALL


# Puertos TCP:  25, 587, 465, 110, 143, 995, 993

***SMTP*** Simple Mail Trasport Protocol: 25, 587 y 465 con SSL/TLS, 2525, 25025 
***ESMTP*** (Extended Simple Mail Transfer Protocol), extension de SMTP con mas comandos de control
***S/MIME*** (Secure/Multipurpose Internet Mail Extensions): 

***POP3*** (Post Office Protocol)::110 y 995 con SSL/TLS

***IMAP***  (Internet Message Access Protocol): 143, 993 con SSL/TLS

# envio email desde consola linux

echo "This is the body of the email" | mail -s "This is the subject line" your_email_address

echo -e 'Subject: prueba\n\nPrueba' | sendmail -v antonio.taboada@telefonica.net 

swaks --to hackingyseguridad@hackingyseguridad.com --server 192.168.1.200


# Registros DNS de seguridad, protocolos y firmas:

***MX*** (Mail Exchanger): tipo de registro DNS, que determinar el fqdm del servidor de correo electrónico para un dominio

dig mx hackingyseguridad.com +short

nslookup -type=txt hackingyseguridad.com 

MX "intercambio de correo" en un registro en la configuración DNS  de un dominio , apunta a los nombre de los servidores de correo electrónico. 

SPF, DKIM y DMARC sirven para autentificar a los remitentes de correo electrónico y cerificar que los correos electrónicos proceden del dominio del que dicen proceder. Estos tres métodos de autenticación son importantes para evitar el spam, los ataques de phishing y otros riesgos de seguridad 

***SPF***, (Sender Policy Framework) es un tipo de resgistro en DNS autoritativo del dominio, donde se especifica los hostname o IP de los servidores de correo saliente, SMTP autorizados.

dig txt hackingyseguridad.com +short

nslookup -type=txt hackingyseguridad.com

dig spf1 hackingyseguridad.com +short

***DKIN***, (DomainKeys Identified Mail) protocolo de identidad, integridad que inserta firma cifrada en la cabecera del email, que certifica al destinatario que es veridico.

***DMARK***,  (Domain-based Message Authentication, Reporting, and Conformance) es una política de correo electrónico que combina, tiene en cuenta SPF y DKIN, para confirmar la legitimidad del dominio en el origen FROM del email, la autenticación coincida con el dominio del «From:». 


<img style="float:left" alt="Proceso de comprobacion del correo electronio " src="https://github.com/hackingyseguridad/email/blob/main/correo.png">


Agregar relay a postfix:

vim /etc/postfix/main.cf

relayhost = IP_realy_smpt


