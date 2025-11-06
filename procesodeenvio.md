
Proceso de envío de un correo electrónico; 
1. Composición del Correo: en el Cliente de Correo "Pesado",  en el cliente Web "ligero", ó con un script en pythom, Bash Shell,..
Se detalla la dirección de email del destinatario TO:, asunto Subject: y texto del correo...

2. Conexión y autenticación con nuestro servidor de salida de correo SMTP.- Antes de enviar "Enviar", el cliente conecta y autentica con SMTP .- Configurado: Autenticas con el nombre de la cuenta@dominio y contraseña.

3. Consultas DNS: 
Consulta el dominio origen: registro MX, el registro A que apunta a la IP.
Consulta el dominio destino: consulta MX: el servidor SMTP pregunta al DNS: registro MX. El DNS responde con uno o más fqdn de servidores de correo. Consulta A/AAAA: para obtener la dirección IP del servidor destino;

3bis. Consultas DNS: Comprobaciones de Seguridad y Políticas. El servidor SMTP realiza varias consultas para asegurar la entrega e impedir la suplanación/spam.
Registro TXT, SPF (Sender Policy Framework): El servidor del destino verifica en el DNS del dominio origen si la IP del servidor SMTP que está enviando el correo está autorizada para enviar correos en nombre de midominio.com. Esto evita la suplantación de identidad (spoofing).
Registro TXT, DKIM (DomainKeys Identified Mail): Es una "firma digital" del mensaje que también se verifica contra un registro DNS del dominio origen, garantizando que el correo no fue alterado en tránsito.
Registro TXT, DMARC (Domain-based Message Authentication, Reporting & Conformance): Política publicada en DNS que le dice al receptor qué hacer si fallan SPF o DKIM (ej: rechazar el correo).

4. Envio del email , con protocolo SMTP: Una vez tiene la IP del servidor de destino, el servidor SMTP inicia una conversación directa con el servidor de destino 
Usando comandos SMTP (HELO, MAIL FROM:, RCPT TO:, DATA), transfiere el email..

5. Entrega final y almacenamiento en la caperta de la cuenta de destino;  El servidor de destino POP3, IMAP,  de entrada si su politica lo ve oK,  acepta el mensaje, realiza sus propias comprobaciones (spam, virus) y si todo está bien, lo guarda en la caperta de entrada del buzón del destinatario. El destinatario al autenticarse con su cuenta@dominio de y abrir su cliente de correo, descargará o verá el email. 

[TÚ] -> [Cliente de Correo] -> (Autenticación) -> [Tu Servidor SMTP]
                                                              v
(Comprobaciones DNS: MX, SPF, DKIM del destino Y del origen)
                                                              v
[Tu Servidor SMTP] -> (Transferencia vía SMTP) -> [Servidor de Correo Destino] -> [Buzón del Destinatario]

El proceso es una combinación de interacción con el servidor (SMTP) y una serie de consultas DNS esenciales para enrutar el correo correctamente y verificar su autenticidad y enviarlo al servidor destino
