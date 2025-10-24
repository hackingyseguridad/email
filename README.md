### suplantar dirección de email

**manipulando el campo "From"**. en el envio del email.- algunos SMTP (Simple Mail Transfer Protocol) no verifican de manera estricta la autenticidad del remitente. 

**Uso de servidores SMTP no seguros**:Los atacantes pueden usar servidores de correo mal configurados o comprometidos que permiten enviar emails sin autenticación. Esto les da libertad para falsificar el remitente.

**Modificación de cabeceras X del correo:Las cabeceras de un email (como "From", "Reply-To" o "Return-Path")  Un atacante puede alterar estas cabeceras para que el correo parezca legítimo en clientes de correo que no realizan verificaciones profundas.

Explotación de dominios similares:Los atacantes pueden registrar dominios parecidos al original (por ejemplo, "b4nco.com" en lugar de "banco.com") y enviar correos desde allí. Esto no es suplantación directa, pero engaña al usuario por la similitud visual.

Compromiso de cuentas reales:Si un atacante obtiene acceso a una cuenta de correo legítima (por ejemplo, mediante phishing o credenciales robadas), puede enviar correos desde esa cuenta, lo que técnicamente no es spoofing, pero logra el mismo efecto de engaño.

Uso de herramientas automatizadas:Existen herramientas y scripts (como PHPMailer o programas de envío masivo) que facilitan la falsificación de correos. Estas herramientas permiten a los atacantes configurar fácilmente el campo "From" con cualquier dirección.




## envio email con telnet o netcat

<img style="float:left" alt="smtp " src="https://github.com/hackingyseguridad/email/blob/main/smtp.png">

# 

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

# leer email con telnet

telnet pop3.hackingyseguridad.com 110

user antonio25

pass Passwd01

list

1

quit

# puertos tcp:  25, 587, 465, 110, 143, 995, 993

***SMTP*** Simple Mail Trasport Protocol: 25, 587 y 465 con SSL/TLS, 2525, 25025 
***ESMTP*** (Extended Simple Mail Transfer Protocol), extension de SMTP con mas comandos de control
***S/MIME*** (Secure/Multipurpose Internet Mail Extensions): 

***POP3*** (Post Office Protocol)::110 y 995 con SSL/TLS

***IMAP***  (Internet Message Access Protocol): 143, 993 con SSL/TLS

# envio email desde consola linux

echo "This is the body of the email" | mail -s "This is the subject line" your_email_address

echo -e 'Subject: prueba\n\nPrueba' | sendmail -v antonio.taboada@telefonica.net 

swaks  --from admin@hackingyseguridad.com --to hackingyseguridad@hackingyseguridad.com --server 192.168.1.200

swaks --to antonio.taboada@telefonica.net --from antonio.taboada@telefonica.net --body "Mensaje de prueba"

echo "<html><body><h1>Hola</h1></body></html>" | sendmail -t -oi destinatario@example.com

swaks --to destinatario@example.com --from tucorreo@example.com --server smtp.example.com --body "<html><body><h1>Hola</h1></body></html>" --h-Content-Type "text/html"

nc -v smtp.hackingyseguridad.com 25

openssl s_client -starttls smtp -connect mail.hackingyseguridad.com:587

gnutls-cli mail.hackingyseguridad.com -p 25

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

<img style="float:left" alt="Proceso de comprobacion del correo electronio " src="https://github.com/hackingyseguridad/email/blob/main/correo.png">

***DMARK***,  (Domain-based Message Authentication, Reporting, and Conformance) es una política de correo electrónico que combina, tiene en cuenta SPF y DKIN, para confirmar la legitimidad del dominio en el origen FROM del email, la autenticación coincida con el dominio del «From:». 
**Uso:** Define políticas para manejar emails que fallan SPF/DKIM y reporta resultados.

**Configuración:**
- Registro **TXT** en el DNS
- Nombre: `_dmarc.tudominio.com`
- Ejemplo: `v=DMARC1; p=quarantine; rua=mailto:reportes@tudominio.com`

### **Resumen de ubicación:**
| Registro | Tipo DNS | Donde se configura |
|----------|----------|-------------------|
| SPF | TXT | Panel DNS del dominio |
| DKIM | TXT | Subdominio específico en DNS |
| DMARC | TXT | `_dmarc` subdominio en DNS |

**Importante:** Los tres trabajan juntos para mejorar la deliverabilidad y prevenir spoofing/phishing.


Agregar SMTP relay a postfix:

vim /etc/postfix/main.cf

relayhost = IP_realy_smpt

#

###
#
http://www.hackingyseguridad.com/
#

