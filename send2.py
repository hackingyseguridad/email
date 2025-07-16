import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import dns.resolver
import random
import hashlib
import base64

class EmailSender:
    def __init__(self):
        self.smtp_server = "localhost"
        self.smtp_port = 25
        self.sender = "hackingyseguridad@hackingyseguridad.com"
        self.recipient = "antonio.taboada@gmail.com"

    def simulate_spf(self, ip_address, domain):
        """Simula una verificación SPF básica"""
        # En una implementación real, esto consultaría los registros DNS SPF
        print(f"\n[SPF SIMULATION] Verificando IP {ip_address} contra SPF de {domain}")

        # Simulación de resultados posibles
        spf_results = {
            "pass": f"IP {ip_address} está autorizada por SPF para {domain}",
            "fail": f"IP {ip_address} NO está autorizada por SPF para {domain}",
            "neutral": f"SPF de {domain} no especifica si la IP está autorizada",
            "softfail": f"IP {ip_address} no está explícitamente autorizada por SPF para {domain}",
            "none": f"Dominio {domain} no tiene registro SPF"
        }

        # Seleccionar un resultado aleatorio para la simulación
        result = random.choice(list(spf_results.keys()))
        print(f"Resultado SPF: {spf_results[result]}")
        return result

    def simulate_dkim(self, domain):
        """Simula una verificación DKIM básica"""
        print(f"\n[DKIM SIMULATION] Verificando firma DKIM para {domain}")

        # Simulación de firma DKIM
        dkim_selector = "selector1"
        dkim_domain = domain
        dkim_result = random.choice([True, False])

        if dkim_result:
            print(f"Firma DKIM válida encontrada (selector={dkim_selector}, domain={dkim_domain})")
        else:
            print("Firma DKIM no válida o no encontrada")

        return dkim_result

    def simulate_dmarc(self, domain):
        """Simula una verificación DMARC básica"""
        print(f"\n[DMARC SIMULATION] Verificando política DMARC para {domain}")

        # Simulación de políticas DMARC
        policies = {
            "none": "No se toma acción específica (monitoreo)",
            "quarantine": "Los correos fallidos deben ser puestos en cuarentena",
            "reject": "Los correos fallidos deben ser rechazados"
        }

        policy = random.choice(list(policies.keys()))
        print(f"Política DMARC encontrada: {policy} - {policies[policy]}")
        return policy

    def create_email(self):
        """Crea el mensaje de email con encabezados personalizados"""
        msg = MIMEMultipart()
        msg["From"] = self.sender
        msg["To"] = self.recipient
        msg["Subject"] = "Asunto importante: Actualización de seguridad"

        # Añadir encabezados de autenticación simulados
        msg["Authentication-Results"] = "spf=pass smtp.mailfrom=bancosantander.es; dkim=pass header.d=bancosantander.es; dmarc=pass"
        msg["Received-SPF"] = "Pass (sender SPF authorized)"
        msg["DKIM-Signature"] = self.generate_dkim_signature()

        body = """
        Estimado cliente,

        Por motivos de seguridad, necesitamos que verifique sus datos accediendo al siguiente enlace:
        http://phishing-site.com/update

        Atentamente,
        Equipo de Seguridad del Banco
        """
        msg.attach(MIMEText(body, "plain"))
        return msg

    def generate_dkim_signature(self):
        """Genera una firma DKIM simulada"""
        dkim_headers = "v=1; a=rsa-sha256; c=relaxed/relaxed; d=bancosantander.es; s=selector1;"
        hash_data = hashlib.sha256(str(random.random()).encode()).hexdigest()
        signature = base64.b64encode(hash_data.encode()).decode()
        return f"{dkim_headers} bh={hash_data}; b={signature};"

    def send_email(self):
        """Envía el email con las verificaciones de seguridad simuladas"""
        try:
            # Simular verificaciones de seguridad
            domain = self.sender.split('@')[1]
            self.simulate_spf("192.168.1.100", domain)
            self.simulate_dkim(domain)
            self.simulate_dmarc(domain)

            # Crear y enviar el email
            message = self.create_email()

            with smtplib.SMTP(self.smtp_server, self.smtp_port) as server:
                server.sendmail(self.sender, self.recipient, message.as_string())

            print("\n[RESULTADO] Correo enviado exitosamente con autenticación simulada")
        except Exception as e:
            print(f"\n[ERROR] Ocurrió un error: {str(e)}")

if __name__ == "__main__":
    sender = EmailSender()
    sender.send_email()

