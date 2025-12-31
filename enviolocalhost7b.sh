
postsuper -d ALL

send_email() {
    local from="notificaciones@google.com"
    local to="antonio.taboada@telefonica.net"
    local dkim_time=$(date +%s)
    local arc_time=$((dkim_time - 1))

    swaks --to "$to" \
          --from "$from" \
          --server localhost \
          --h-Subject "prueba de envio" \
          --h-From "Notificaciones Google <$from>" \
          --h-Date "Wed, 31 Dec 2025 15:52:44 +0100" \
          --h-Message-ID "<CAFNJDUAedPKpxHsqddNdMveGgyR0Gy6YE4xHM8cN1UJMV6aQmw@mail.gmail.com>" \
          --h-X-Mailer "Google Mail" \
          --h-X-Google-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net; s=20230601; t=$dkim_time" \
          --h-DKIM-Signature "v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20230601; t=$dkim_time" \
          --h-ARC-Authentication-Results "i=1; mx.google.com; dkim=pass header.i=@gmail.com; spf=pass; dmarc=pass" \
          --h-Authentication-Results "mx.google.com; dkim=pass; spf=pass; dmarc=pass" \
          --h-Received-SPF "pass (google.com: domain of $from designates 209.85.220.41 as permitted sender)" \
          --data "From: Notificaciones Google <$from>
To: $to
Subject: prueba de envio
X-Mailer: Google Mail
X-Priority: 1
Importance: high

hola, esto es una prueba de envio de correo electronico

un saludo,

http://www.hackingyseguridad.com/"
}

send_email

