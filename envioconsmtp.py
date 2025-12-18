#############################################################
# Simple script en Python version 3
# envvia email con SMTP externo, auth login, sin cifrado! 
# funciona para spoof basico!
# http://wwww.hackingyseguridad.com 2025
############################################################

import socket
import base64
import time

def send_smtp_commands():
    try:
        # Conecta al servidor SMTP externo puerto 25/tcp
        print("Conectando a smtp.hackingyseguridad.com:25...")
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(("smtp.telefonica.net", 25))

        # Función para enviar comandos SMTP y recibir respuestas
        def send_command(command=None):
            if command:
                print(f"Enviando: {command}")
                sock.send(f"{command}\r\n".encode())
                time.sleep(0.5)

            response = sock.recv(1024).decode()
            print(f"Respuesta: {response.strip()}")
            return response

        # Iniciar conversación SMTP
        send_command()  # Banner inicial

        # HELO
        send_command("helo relay.hackingyseguridad.com")

        # AUTH LOGIN
        send_command("AUTH LOGIN")

        # Usuario (ya en base64)
        send_command("aGFja2luZ3lzZWd1cmlkYWRAaGFja2luZ3lzZWd1cmlkYWQuY29t")

        # Contraseña (ya en base64)
        send_command("UGFzc3dkMDA=")

        # MAIL FROM
        send_command("MAIL FROM: antonio.taboadallufriu@hackingyseguridad.com")

        # RCPT TO - múltiples destinatarios
        recipients = [
            "antonio.taboadallufriu@hackingyseguridad.com",
            "antonio.taboadallufriu@hackingyseguridad.com",
        ]

        for recipient in recipients:
            send_command(f"RCPT TO: {recipient}")

        # DATA
        send_command("data")

        # Cabeceras del email
        message = """From: antonio.taboadallufriu@hackingyseguridad.com
To: antonio.taboadallufriu@hackingyseguridad.com, antonio.taboadallufriu@hackingyseguridad.com
Subject: Prueba de envio y spoof
Date: {}

HappyHacking !

@antonio_taboada  - http://www.hackingyseguridad.com/

.""".format(time.strftime("%a, %d %b %Y %H:%M:%S +0000", time.gmtime()))

        # Enviar mensaje línea por línea
        print("Enviando mensaje DATA...")
        for line in message.split('\n'):
            if line.strip():  # Evitar líneas vacías
                sock.send(f"{line}\r\n".encode())
                time.sleep(0.1)

        # Finalizar DATA y enviar QUIT
        send_command()  # Respuesta del DATA
        send_command("quit")

        sock.close()
        print("✓ Conexión cerrada")

    except Exception as e:
        print(f"✗ Error: {e}")

if __name__ == "__main__":
    send_smtp_commands()



