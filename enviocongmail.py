###########################################################################
# Simple Script en Python version 3
# envia correo  con smtp.mail.com y spoof origen, en la descripcion del form
# simple Spoffing modificando el FORM del email
# hackingyseguridad.com 2025
############################################################################


import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import ssl
from email.utils import formataddr

class CustomSender:
    def __init__(self):
        self.smtp_server = "smtp.gmail.com"
        self.smtp_port = 587
        self.gmail_account = "antonio.tab@gmail.com"
        self.app_password = "satk lnxi lpti vav"
        self.display_email = "emailsuplantado@hackingyseguridad.com"
        self.display_name = "emailsuplantado@hackingyseguridad.com"
        self.recipients = {
            'to': ["antonio.taboada@hackingyseguridad.com"],
            'cc': ["antonio.taboada@hackingyseguridad.com"],
            'bcc': ["antonio.taboada@hackingyseguridad.com"]
        }

    def prepare_email(self):
        msg = MIMEMultipart()
        msg["From"] = formataddr((self.display_name, self.display_email))
        msg["To"] = ", ".join(self.recipients['to'])

        if self.recipients['cc']:
            msg["Cc"] = ", ".join(self.recipients['cc'])

        msg["Subject"] = "Actualización importante de su pedido "
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

                print("✓ Correo enviado exitosamente!")

        except Exception as e:
            print(f"✗ Error: {e}")

if __name__ == "__main__":
    sender = CustomSender()
    sender.send_email()


