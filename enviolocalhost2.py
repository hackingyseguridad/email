#######################################################################################################
# Script en Python 3 ,
# suplanta con postfix en localhost puerto 25 TCP
# suplanta email origen p.ej.:  self.custom_from = ("root@localhost, "root@localhost")
# (r) http://www.hackingyseguridad.com 2025
########################################################################################################

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.utils import formataddr

class CustomSender:
    def __init__(self):
        self.smtp_server = "localhost"   # servidor SMTP
        self.smtp_port = 25   # puerto TCP del servidor SMTP
        self.custom_from = ("root@locahost", "root@localhost")  # cuenta de correo origen
        self.recipients = {
            'to': ["admin@localhost"],
            'cc': ["antonio.taboada@hackingyseguridad.com"],
            'bcc': ["antonio.taboada@hackingyseguridad.com"]
        }

    def prepare_email(self):
        msg = MIMEMultipart()
        msg["From"] = formataddr(self.custom_from)
        msg["To"] = ", ".join(self.recipients['to'])
        if self.recipients['cc']:
            msg["Cc"] = ", ".join(self.recipients['cc'])
        msg["Subject"] = "PoC suplantacion email"
        msg["Reply-To"] = self.custom_from[1]
        msg["Return-Path"] = self.custom_from[1]

        body = """Hello ,
        ...
        ...
        ...



        """
        msg.attach(MIMEText(body, "plain"))
        return msg

    def send_email(self):
        try:
            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.ehlo()
                message = self.prepare_email()
                all_recipients = (
                    self.recipients['to'] +
                    self.recipients.get('cc', []) +
                    self.recipients.get('bcc', [])
                )
                server.sendmail(
                    self.custom_from[1],  # Usar el email del remitente
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

