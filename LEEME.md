
```
███████╗██████╗  ██████╗  ██████╗ ███████╗    ███████╗███╗   ███╗ █████╗ ██╗██╗     
██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝    ██╔════╝████╗ ████║██╔══██╗██║██║     
███████╗██████╔╝██║   ██║██║   ██║█████╗      █████╗  ██╔████╔██║███████║██║██║     
╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝      ██╔══╝  ██║╚██╔╝██║██╔══██║██║██║     
███████║██║     ╚██████╔╝╚██████╔╝██║         ███████╗██║ ╚═╝ ██║██║  ██║██║███████╗
╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚═╝         ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝
```

### Email/SCAM/Spoofing/Phissing

**Introduccion :** 

La suplantación real de email, depende en gran medida de:

1.- La configuración de verificaciones SPF, DKIN y DMARK, del SMTP origen y registros TXT en los DNS autoritativos del dominio.

2.- De la posibilidad de modificar el valor del campo FRORM del email origen;

3.- De los filtros, de la política DMARK en el servidor de entrada en destino, con verificaciones falsas (permitir, cuarentena o denegar).

El engaño y phissing en email, depende de: los X-Mail, servidores fake o manipulacon de caracteres.

**Proceso de envio de correo :**

1. Composición del Correo: cliente de correo ( outlook, thunderbird, "pesado", cliente Web "ligero" ó con  script en pythom, Bash Shell,..
   FORM: cuenta.origen@dominio1.com, por defecto lo imprime nuestro servidor SMTP
   TO: cuenta.destino@dominio2.com, indicamos la **dirección de email del destinatario**,
   Subject: asunto del email
   Texto: correo electronico ..  

2. Conexión con el servidor de correo saliente SMTP, antes de "enviar", ha autenticado con usuario cuenta.origen@dominio1.com y password.

3. Consultas al DNS: 
Consulta el dominio origen: registro MX, el registro A que apunta a la IP.
Consulta el dominio destino: consulta MX: el servidor SMTP pregunta al DNS: registro MX. El DNS responde con uno o más fqdn de servidores de correo. Consulta A/AAAA: para obtener la dirección IP del servidor destino;

3. Bis. Consultas DNS: Comprobaciones de Seguridad y Políticas. El servidor SMTP realiza varias consultas para asegurar la entrega e impedir la suplanación/spam.
Registro TXT, SPF (Sender Policy Framework): El servidor del destino verifica en el DNS del dominio origen si la IP del servidor SMTP que está enviando el correo está autorizada para enviar correos en nombre de midominio.com. Esto evita la suplantación de identidad (spoofing).
Registro TXT, DKIM (DomainKeys Identified Mail): Es una "firma digital" del mensaje que también se verifica contra un registro DNS del dominio origen, garantizando que el correo no fue alterado en tránsito. Registro TXT, DMARC (Domain-based Message Authentication, Reporting & Conformance): Política publicada en DNS que le dice al receptor qué hacer si fallan SPF o DKIM (ej: rechazar el correo).

4. Envio del email, protocolo SMTP; una vez tiene la IP del servidor de destino el servidor SMTP envia email al servidor de entrada de destino. 

5. Entrega y almacena en la caperta de la cuenta de destino; El servidor de destino POP3, IMAP de entrada si su politica permite: acepta el mensaje, lo pone en cuarentena o elimina; - Si pasa la politica de entrada, guarda el email en la caperta de entrada del buzón del destinatario. El destinatario al autenticarse con su cuenta.destino@dominio2.com y abrir su cliente de correo, descargará o verá el email. 

**SMTP (Simple Mail Transfer Protocol)** es un protocolo de comunicación estándar de Internet para dar salida, enviar correos electrónicos (email).


<img style="float:left" alt="smtp " src="https://github.com/hackingyseguridad/email/blob/main/smtp.png">


### Puertos usuales TCP:  25, 587, 465, 110, 143, 995, 993

***SMTP*** Simple Mail Trasport Protocol. el servicio en un servidor activo, normalmente usa el puerto TCP: 25, 587 y 465 con SSL/TLS, 2525, 25025 

***ESMTP*** (Extended Simple Mail Transfer Protocol), extension de SMTP con mas comandos de control

***S/MIME*** (Secure/Multipurpose Internet Mail Extensions): 

***POP3*** (Post Office Protocol)::110 y 995 con SSL/TLS

***IMAP***  (Internet Message Access Protocol): 143, 993 con SSL/TLS


### Registros DNS de seguridad, protocolos y firmas; para evitar suplantacion SCAM/Spoofing/Phissing

[DNS](https://github.com/hackingyseguridad/dns) autoritativos; son los servidores maestros que contienen la información oficial y definitiva de un dominio.

Tipos principales de registros DNS:

**A/AAAA :** Asocian dominio → IPv4 (A) o IPv6 (AAAA)

**CNAME :** Crea alias (ej: www apunta a dominio principal)

**NS :** Indica qué servidores DNS son autoritativos para el dominio

**MX** (Mail Exchanger): tipo de registro DNS, MX: Especifica servidores de correo electrónico. que determina el fqdm del servidor de correo electrónico para un dominio. MX "intercambio de correo" en un registro en la configuración DNS  de un dominio , apunta a los nombre de los servidores de correo electrónico. 

**TXT :** Almacena información textual (verificaciones, seguridad)

**SPF, DKIM y DMARC** sirven para autentificar a los remitentes de correo electrónico y cerificar que los correos electrónicos proceden del dominio del que dicen proceder. Estos tres métodos de autenticación son importantes para evitar el spam, los ataques de phishing y otros riesgos de seguridad 

**SPF**, (Sender Policy Framework) es un tipo de resgistro en DNS autoritativo del dominio, donde se especifica los hostname o IP de los servidores de correo saliente, SMTP autorizados, para enviar con el nombre de ese dominio.

  $dig mx hackingyseguridad.com +short

  $nslookup -type=txt hackingyseguridad.com 

  $dig TXT hackingyseguridad.com | grep "spf

  $dig txt hackingyseguridad.com +short

  $nslookup -type=txt hackingyseguridad.com

  $dig spf1 hackingyseguridad.com +short

***DKIN***, (DomainKeys Identified Mail) protocolo de identidad, integridad que inserta firma cifrada en la cabecera del email, que certifica al destinatario que es veridico.

<img style="float:left" alt="Proceso de comprobacion del correo electronio " src="https://github.com/hackingyseguridad/email/blob/main/correo.png">

***DMARK***,  (Domain-based Message Authentication, Reporting, and Conformance) es una política de correo electrónico que combina, tiene en cuenta SPF y DKIN, para confirmar la legitimidad del dominio en el origen FROM del email, la autenticación coincida con el dominio del «From:». 
**Uso:** Define políticas para manejar emails que fallan SPF/DKIM y reporta resultados.  
DMARC tiene 3 niveles de seguridad: 1º.- (No hacer nada / monitorizar) 2º.- (Poner en Cuarentena) 3º.- (Rechazar)

<img style="float:left" alt="DMARK " src="https://github.com/hackingyseguridad/email/blob/main/dmark.png">

**Configuración:**
- Registro **TXT** en el DNS autoritativo del dominio
- Nombre: `_dmarc.tudominio.com`
- Ejemplo: `v=DMARC1; p=quarantine; rua=mailto:reportes@tudominio.com`

### **Resumen de ubicación:**
| Registro | Tipo DNS | Donde se configura |
|----------|----------|-------------------|
| SPF | TXT | Panel DNS del dominio |
| DKIM | TXT | Subdominio específico en DNS |
| DMARC | TXT | `_dmarc` subdominio en DNS |

**Importante:** Los tres trabajan juntos para mejorar la deliverabilidad y prevenir spoofing/phishing.





### Suplantar dirección de email, correo electronico (tecnicas SCAM/Spoofing/Phissing).

**1º.- Manipulando el campo "From"**. del email, con script de envio.- algunos servidores SMTP (Simple Mail Transfer Protocol) no verifican el remitente FORM.
[https://github.com/hackingyseguridad/email/blob/main/enviopythonsmtp.py ](https://github.com/hackingyseguridad/email/blob/main/envioconsmtp.py)

**2º.- Modificación de cabeceras X-Mailer del correo** : cabeceras del email como: "From", "Reply-To" o "Return-Path",.. con scripts de envio ... [https://github.com/hackingyseguridad/email/blob/main/suplantacongmailcabeceras.py  ](https://github.com/hackingyseguridad/email/blob/main/enviocongmail3.py)

**3º.- Uso de servidores SMTP Open Relay (sin autenticación), no seguros**: pueden usarse estos servidores de correo mal configurados o comprometidos para enviar emails, de forma libre, modificando el FROM y/o cabeceras X-Mailer 

**4º.- Explotación de un servidor SMTP**, por fuerza bruta o explotando otras vulnerabilidades CVE.

**5º.- Compromiso de cuentas reales**  :Si un atacante obtiene acceso a una cuenta de correo legítima (por ejemplo, mediante phishing, fuerza bruta o credenciales robadas.

**6º.- Uso de herramientas automatizadas** : scripts (como PHPMailer o programas de envío masivo) que facilitan la falsificación de correos. 

**7º.- Uso de un dominio muy parecido** ; que visualmente sea disficil de notar que existe un caracter distinto.

**8º.- Uso de un servidor SMTP, DNS, propio**, ad hoc que simule las cuentas, dominio, falsifique registros y verificaciones: SPF, DKIM, DMARK. (DMARK modo, dejar pasar). https://github.com/hackingyseguridad/email/blob/main/enviolocalhostdnark2.py

**9º.- Uso de SMPT de otros proveedores paraa engañar**, simular la descripcion del email origen en el Form, si este SMTP no imprime datos del email origen real. 

**10º.- Uso de un servidor SMTP, que este en el SPF de otros dominios**, comparte infraestructura e IPs permitidas (diseño de la arquitectura de red).


### Envio basico de email con telnet o netcat, conectado a SMTP

# 

nc -v smtp.hackingyseguridad.com 25

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

### Ordenaes para el servidor, conectado a SMTP

**Ver correos en cola, pendientes de enviar**

mailq

postqueue -f

**Borrar toda la cola**

postsuper -d ALL

### Leer email con telnet, desde consola

telnet pop3.hackingyseguridad.com 110

user antonio25

pass Passwd01

list

1

quit


### Envio simple de email desde consola linux, con comandos basicos

echo "This is the body of the email" | mail -s "This is the subject line" your_email_address

echo -e 'Subject: prueba\n\nPrueba' | sendmail -v antonio.taboada@telefonica.net 

swaks  --from admin@hackingyseguridad.com --to hackingyseguridad@hackingyseguridad.com --server 192.168.1.200

swaks --to antonio.taboada@telefonica.net --from antonio.taboada@telefonica.net --body "Mensaje de prueba"

echo "Hola_" | sendmail -t -oi destinatario@example.com

swaks --to destinatario@example.com --from tucorreo@example.com --server smtp.example.com --body "Hola_" --h-Content-Type "text/html"

nc -v smtp.hackingyseguridad.com 25

openssl s_client -starttls smtp -connect mail.hackingyseguridad.com:587

gnutls-cli mail.hackingyseguridad.com -p 25


## Configuraciones servidor SMTP Postfix

***Postfx como servidor SMTP***

[mail.cf.txt](https://github.com/hackingyseguridad/email/blob/main/mail.cf.txt)

***Agregar SMTP relay de  gmail Google a postfix:***

vim /etc/postfix/main.cf

relayhost = IP_realy_smpt

[postfix_relay_gmail.txt](https://github.com/hackingyseguridad/email/blob/main/postfix_relay_gmail.txt)

### Proveedores gratuitos de envio de email.

***Yahoo :***    		smtp.mail.yahoo.com:587

***Hotmail :***			smtp.live.com:587

***Gmail de Google :***		smtp.gmail.com:25

***Gmail de Google :*** 	smtp-relay.gmail.com:25

***Microsoft Office 365 :***	smtp.office365.com:587	


###
#
http://www.hackingyseguridad.com/
#
###

