### Email/SCAM/Spoofing/Phissing


<img style="float:left" alt="smtp " src="https://github.com/hackingyseguridad/email/blob/main/smtp.png">


### Puertos usuales TCP:  25, 587, 465, 110, 143, 995, 993

***SMTP*** Simple Mail Trasport Protocol: 25, 587 y 465 con SSL/TLS, 2525, 25025 

***ESMTP*** (Extended Simple Mail Transfer Protocol), extension de SMTP con mas comandos de control

***S/MIME*** (Secure/Multipurpose Internet Mail Extensions): 

***POP3*** (Post Office Protocol)::110 y 995 con SSL/TLS

***IMAP***  (Internet Message Access Protocol): 143, 993 con SSL/TLS


### Registros DNS de seguridad, protocolos y firmas; para evitar suplantacion SCAM/Spoofing/Phissing

***MX*** (Mail Exchanger): tipo de registro DNS, que determinar el fqdm del servidor de correo electrónico para un dominio

dig mx hackingyseguridad.com +short

nslookup -type=txt hackingyseguridad.com 

MX "intercambio de correo" en un registro en la configuración DNS  de un dominio , apunta a los nombre de los servidores de correo electrónico. 

SPF, DKIM y DMARC sirven para autentificar a los remitentes de correo electrónico y cerificar que los correos electrónicos proceden del dominio del que dicen proceder. Estos tres métodos de autenticación son importantes para evitar el spam, los ataques de phishing y otros riesgos de seguridad 

***SPF***, (Sender Policy Framework) es un tipo de resgistro en DNS autoritativo del dominio, donde se especifica los hostname o IP de los servidores de correo saliente, SMTP autorizados.

dig TXT hackingyseguridad.com | grep "spf

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





### Suplantar dirección de email, correo electronico ( tecnicas SCAM/Spoofing/Phissing ).

**1º.- Manipulando el campo "From"**. del email, con script de envio.- algunos servidores SMTP (Simple Mail Transfer Protocol) no verifican el remitente. 

**2º.- Modificación de cabeceras X-Mailer del correo** : cabeceras del email como: "From", "Reply-To" o "Return-Path",.. con scripts de envio..  

**3º.- Uso de servidores SMTP Open Relay (sin autenticación), no seguros**: pueden usarse estos servidores de correo mal configurados o comprometidos para enviar emails, de dorma libre, modificando el Form y/o cabeceras X-Mailer

**4º.- Explotación de un servidor SMTP**, por fuerza bruta o explotando otras vulnerabilidades.

**5º.- Compromiso de cuentas reales**  :Si un atacante obtiene acceso a una cuenta de correo legítima (por ejemplo, mediante phishing o credenciales robadas.

**6º.- Uso de herramientas automatizadas** : scripts (como PHPMailer o programas de envío masivo) que facilitan la falsificación de correos. 

**7º.- Uso de un dominio muy parecido** ; que visualmente sea disficil de notar que existe un caracter distinto.

**8º.- Uso de un servidor SMTP, DNS, propio**, adhoc que simule las cuentas y dominio, falsifique SPF, DKIM, DMARK. ( DMARK 3 modos ).

**9º.- Uso de SMPT de otros proveedores paraa engañar**, simular la descripcion del email origen en el Form, si este SMTP no imprime datos del email origen real. 

**10º.- Uso de un smtp que este en el SPF de otros dominios**, comparta infraestructura e IPs


### Envio basico de email con telnet o netcat, conectado a SMTP

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

### Leer email con telnet, desde consola

telnet pop3.hackingyseguridad.com 110

user antonio25

pass Passwd01

list

1

quit


### Envio simple de email desde consola linux, con comandos

echo "This is the body of the email" | mail -s "This is the subject line" your_email_address

echo -e 'Subject: prueba\n\nPrueba' | sendmail -v antonio.taboada@telefonica.net 

swaks  --from admin@hackingyseguridad.com --to hackingyseguridad@hackingyseguridad.com --server 192.168.1.200

swaks --to antonio.taboada@telefonica.net --from antonio.taboada@telefonica.net --body "Mensaje de prueba"

echo "<html><body><h1>Hola</h1></body></html>" | sendmail -t -oi destinatario@example.com

swaks --to destinatario@example.com --from tucorreo@example.com --server smtp.example.com --body "<html><body><h1>Hola</h1></body></html>" --h-Content-Type "text/html"

nc -v smtp.hackingyseguridad.com 25

openssl s_client -starttls smtp -connect mail.hackingyseguridad.com:587

gnutls-cli mail.hackingyseguridad.com -p 25


## Configuraciones servidor SMTP Postfix

Agregar SMTP relay a postfix:

vim /etc/postfix/main.cf

relayhost = IP_realy_smpt

#

###
#
http://www.hackingyseguridad.com/
#

