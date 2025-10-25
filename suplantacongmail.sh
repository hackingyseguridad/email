############################################################
# Script en Python3 qye usa el SMTP de gmail 
# Suplanta en el Form, con email spoof
# funciona!
# http://www.hackingyseguridad.com
###########################################################

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import ssl
from email.utils import formataddr

class CustomSender:
    def __init__(self):
        self.smtp_server = "smtp.gmail.com"
        self.smtp_port = 587
        self.gmail_account = "antonio.taboada@gmail.com"
        self.app_password = "satk lnxi lpti vav"
        self.display_email = "correosuplantado@dominio.com"
        self.display_name = "correosuplantado@dominio.com"
        self.recipients = {
            'to': ["antonio.taboada@gmail.com"],
            'cc': ["antonio.taboada@gmail.com"],
            'bcc': ["antonio.taboada@gmail.com"]
        }

    def prepare_email(self):
        msg = MIMEMultipart()
        msg["From"] = formataddr((self.display_name, self.display_email))
        msg["To"] = ", ".join(self.recipients['to'])

        if self.recipients['cc']:
            msg["Cc"] = ", ".join(self.recipients['cc'])

        msg["Subject"] = "Actualización importante de su pedido"
        msg["Reply-To"] = self.display_email
        msg["Return-Path"] = self.display_email

        body = """
        Hola,

        ---- un saludo, Antonio Taboada -
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
                    self.display_email,
                    all_recipients,
                    message.as_string()
                )

                print("✓ Correo enviado!")

        except Exception as e:
            print(f"✗ Error: {e}")

if __name__ == "__main__":
    sender = CustomSender()
    sender.send_email()


