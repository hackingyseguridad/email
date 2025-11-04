#################################################################################
# Script en Python version 3, para envio desde (postfix) 
# Envio de email, a traves de servidor SMTP en localhost, en local
# Simula, falsifica las verificaciones SPF, DKIN, DMARK, para envio a Gmail.
# Las firmas DKIM son simuladas, no válidas.  Requiere configuracion DNS valida
# Las firmas DKIM requieren claves criptográficas reales
# (r) hackingyseguridad.com 2025
#################################################################################

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import random
import hashlib
import base64
from datetime import datetime

class GmailSecuritySimulator:
    def __init__(self):
        self.smtp_server = "localhost"
        self.smtp_port = 25
        self.sender = "hackingyseguridad@hackingyseguridad.com.es"  # Simulando remitente de Gmail
        self.recipient = "antonio.taboada@gmail.com"
        self.dkim_selector = "20230601"  # Selector DKIM actual de Gmail

    def simulate_gmail_spf(self):
        """Simula la verificación SPF de Gmail"""
        print("\n[SPF SIMULATION] Verificando registros SPF de gmail.com")

        # Registros SPF reales de Google (simplificado)
        google_spf = "v=spf1 include:_spf.google.com ~all"

        print(f"Registro SPF encontrado: {google_spf}")
        print("Google utiliza múltiples IPs autorizadas para enviar correos")

        # Simular resultado (Gmail generalmente pasa SPF cuando se envía desde sus servidores)
        result = "pass" if random.random() > 0.1 else "neutral"  # 90% de probabilidad de pasar
        results = {
            "pass": "IP autorizada por SPF de Google",
            "neutral": "SPF neutral (no afirma autorización)"
        }
        print(f"Resultado: {result.upper()} - {results[result]}")
        return result

    def simulate_gmail_dkim(self):
        """Simula la verificación DKIM de Gmail"""
        print("\n[DKIM SIMULATION] Verificando firma DKIM de Gmail")

        # Datos típicos de DKIM de Gmail
        dkim_domain = "google.com"
        print(f"Buscando selector DKIM: {self.dkim_selector}._domainkey.{dkim_domain}")

        # Simular verificación de firma
        dkim_passed = random.random() > 0.2  # 80% de probabilidad de pasar

        if dkim_passed:
            print("Firma DKIM válida encontrada")
            print("Algoritmo: RSA-SHA256")
            print(f"Selector: {self.dkim_selector}")
        else:
            print("Firma DKIM no válida o no encontrada")

        return dkim_passed

    def simulate_gmail_dmarc(self):
        """Simula la verificación DMARC de Gmail"""
        print("\n[DMARC SIMULATION] Verificando política DMARC de gmail.com")

        # Política DMARC real de Google (simplificada)
        google_dmarc = "v=DMARC1; p=none; rua=mailto:mailauth-reports@google.com"

        print(f"Registro DMARC encontrado: {google_dmarc}")

        # Google usa p=none (solo monitoreo) como política por defecto
        policy = "none"
        print("Política DMARC: none (solo reportes, no acción)")

        return policy

    def generate_gmail_dkim_signature(self):
        """Genera una firma DKIM simulada al estilo Gmail"""
        d = "google.com"
        s = self.dkim_selector
        t = int(datetime.now().timestamp())
        h = "sha256"

        # Encabezados firmados (simulados)
        headers = "from:to:subject:date:mime-version"

        # Cuerpo de la firma (simulado)
        body_hash = hashlib.sha256(str(random.random()).encode()).hexdigest()
        signature = base64.b64encode(f"simulated-signature-{t}".encode()).decode()

        return (f"v=1; a=rsa-sha256; c=relaxed/relaxed; "
                f"d={d}; s={s}; "
                f"t={t}; h={headers}; "
                f"bh={body_hash}; b={signature}")

    def create_gmail_style_email(self):
        """Crea un email con encabezados al estilo Gmail"""
        msg = MIMEMultipart()
        msg["From"] = self.sender
        msg["To"] = self.recipient
        msg["Subject"] = "Actualización de seguridad importante"
        msg["Date"] = datetime.now().strftime("%a, %d %b %Y %H:%M:%S %z")

        # Añadir encabezados de autenticación simulados al estilo Gmail
        msg["Authentication-Results"] = (
            "mx.google.com; "
            "dkim=pass header.i=@google.com header.s=20230601 header.b=\"...\"; "
            "spf=pass (google.com: domain of security@gmail.com designates "
            "allowed senders) smtp.mailfrom=security@gmail.com; "
            "dmarc=pass (p=NONE sp=NONE dis=NONE) header.from=google.com"
        )

        msg["Received-SPF"] = (
            "Pass (mailfrom) identity=mailfrom; "
            "client-ip=209.85.220.41; "
            "helo=mail-oi1-f41.google.com; "
            "envelope-from=security@gmail.com; "
            "receiver=target.example.com"
        )

        msg["DKIM-Signature"] = self.generate_gmail_dkim_signature()

        body = """
        Estimado usuario,

        Hemos detectado actividad inusual en su cuenta. Por favor verifique sus credenciales:

        🔗 https://security.google.com/check-account (enlace simulado)

        Si no reconoce esta actividad, por favor contacte a nuestro equipo de soporte.

        Atentamente,
        Equipo de Seguridad de Google
        """
        msg.attach(MIMEText(body, "plain"))
        return msg

    def send_email(self):
        """Envía el email con las verificaciones de seguridad simuladas"""
        try:
            print("=== SIMULACIÓN DE ENVÍO DE GMAIL CON PROTOCOLOS DE SEGURIDAD ===")

            # Simular verificaciones de seguridad
            self.simulate_gmail_spf()
            self.simulate_gmail_dkim()
            self.simulate_gmail_dmarc()

            # Crear y enviar el email
            message = self.create_gmail_style_email()

            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.sendmail(self.sender, self.recipient, message.as_string())

            print("\n[RESULTADO] Correo estilo Gmail enviado con autenticación simulada")
            print("Nota: Esta es una simulación para fines educativos")
        except Exception as e:
            print(f"\n[ERROR] Ocurrió un error: {str(e)}")

if __name__ == "__main__":
    gmail_simulator = GmailSecuritySimulator()
    gmail_simulator.send_email()
