# envio de email, python  -hackingyseguridad.com
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

try:
    # Configuración del servidor SMTP local
    smtp_server = "localhost"
    smtp_port = 25

    # Datos del remitente y destinatario
    remite = "hackingyseguridad@hackingyseguridad.com"
    destinatario = "antonio.taboada@gmail.com"

    # Crear el mensaje
    mensaje = MIMEMultipart()
    mensaje["From"] = remite
    mensaje["To"] = destinatario
    mensaje["Subject"] = "prueba de envio de correo electronico"

    # Contenido del mensaje
    cuerpo = "email falso !!! http://www.hackingyseguridad.com "
    mensaje.attach(MIMEText(cuerpo, "plain"))

    # Conexión al servidor SMTP local
    servidor_smtp = smtplib.SMTP(smtp_server, smtp_port)

    # Envío del correo electrónico
    servidor_smtp.sendmail(remite, destinatario, mensaje.as_string())

    # Cerrar conexión
    servidor_smtp.quit()

    print("Enviado!")
except Exception as e:
    print(e)
