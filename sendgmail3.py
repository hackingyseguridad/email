# funciona!!

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import ssl

class GmailSender:
    def __init__(self):
        self.smtp_server = "smtp.gmail.com"
        self.smtp_port = 587
        self.sender_email = "antonio.taboada@gmail.com"  # Tu email REAL
        self.app_password = "satk lnxi lpti vavw"  # La contraseña de aplicación generada
        self.recipient = "antonio.taboada@gmail.com"

    def send_email(self):
        try:
            # Configuración segura
            context = ssl.create_default_context()

            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.ehlo()
                server.starttls(context=context)
                server.ehlo()

                # Usa la contraseña de aplicación aquí
                server.login(self.sender_email, self.app_password)

                # Crear mensaje simple
                msg = MIMEMultipart()
                msg["From"] = self.sender_email
                msg["To"] = self.recipient
                msg["Subject"] = "Prueba de correo seguro"

                body = "Este es un correo de prueba enviado usando autenticación segura."
                msg.attach(MIMEText(body, "plain"))

                server.sendmail(self.sender_email, self.recipient, msg.as_string())
                print("Correo enviado exitosamente!")

        except Exception as e:
            print(f"Error al enviar: {str(e)}")

if __name__ == "__main__":
    sender = GmailSender()
    sender.send_email()
