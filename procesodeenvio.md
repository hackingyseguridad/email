
Proceso de envío de un correo electrónico:

1. Composición del Correo: en el cliente de correo "pesado",  en cliente Web "ligero" ó con un script en pythom, Bash Shell,..
   FORM: cuenta.origen@dominio1.com, lo imprime nuestro servidor SMTP
   TO: cuenta.destino@dominio2.com, indicamos la **dirección de email del destinatario**,
   Subject: asunto del email
   Texto: correo electronico ..  

2. Conexión con el servidor de correo saliente SMTP, antes de "Enviar", ha autenticado con usuario cuenta.origen@dominio1.com y password.

3. Consultas al DNS: 
Consulta el dominio origen: registro MX, el registro A que apunta a la IP.
Consulta el dominio destino: consulta MX: el servidor SMTP pregunta al DNS: registro MX. El DNS responde con uno o más fqdn de servidores de correo. Consulta A/AAAA: para obtener la dirección IP del servidor destino;

3.- bis. Consultas DNS: Comprobaciones de Seguridad y Políticas. El servidor SMTP realiza varias consultas para asegurar la entrega e impedir la suplanación/spam.
Registro TXT, SPF (Sender Policy Framework): El servidor del destino verifica en el DNS del dominio origen si la IP del servidor SMTP que está enviando el correo está autorizada para enviar correos en nombre de midominio.com. Esto evita la suplantación de identidad (spoofing).
Registro TXT, DKIM (DomainKeys Identified Mail): Es una "firma digital" del mensaje que también se verifica contra un registro DNS del dominio origen, garantizando que el correo no fue alterado en tránsito.
Registro TXT, DMARC (Domain-based Message Authentication, Reporting & Conformance): Política publicada en DNS que le dice al receptor qué hacer si fallan SPF o DKIM (ej: rechazar el correo).

4. Envio del email, con protocolo SMTP; una vez tiene la IP del servidor de destino el servidor SMTP envia email al servidor de entrada de destino 

5. Entrega final y almacenamiento en la caperta de la cuenta de destino; El servidor de destino POP3, IMAP  de entrada si su politica permite: acepta el mensaje, lo pone en cuarentena o elimina; - Si pasa la politica de entrada, guarda el email en la caperta de entrada del buzón del destinatario. El destinatario al autenticarse con su cuenta.destino@dominio2.com y abrir su cliente de correo, descargará o verá el email. 

[TÚ] -> [Cliente de Correo] -> (Autenticación) -> [Tu Servidor SMTP]
                                                              v
(Comprobaciones DNS: MX, SPF, DKIM del destino Y del origen)
                                                              v
[Tu Servidor SMTP] -> (Transferencia vía SMTP) -> [Servidor de Correo Destino] -> [Buzón del Destinatario]

El proceso es una combinación de interacción con el servidor (SMTP) y una serie de consultas DNS esenciales para enrutar el correo correctamente y verificar su autenticidad y enviarlo al servidor destino
