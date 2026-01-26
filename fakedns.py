

#!/usr/bin/env python3
from dnslib import *
from dnslib.server import DNSServer, DNSLogger
import socket

UPSTREAM_DNS = ("80.58.61.254", 53)
LOCAL_IP = "127.0.0.1"

LOCAL_A_RECORDS = {
    "google.com.",
    "www.google.com.",
    "www2.google.com.",
    "mail.google.com.",
    "smtp.google.com.",
    "pop3.google.com.",
    "imap.google.com.",
}

class MyResolver:
    def resolve(self, request, handler):
        qname = str(request.q.qname)
        qtype = request.q.qtype

        reply = request.reply()
        reply.header.ra = 0  # sin recursión

        # ===== REGISTROS A LOCALES =====
        if qname in LOCAL_A_RECORDS and qtype == QTYPE.A:
            reply.add_answer(
                RR(
                    qname,
                    QTYPE.A,
                    rdata=A(LOCAL_IP),
                    ttl=300
                )
            )

        # ===== TXT / SPF =====
        elif qname == "google.com." and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(
                    qname,
                    QTYPE.TXT,
                    rdata=TXT("v=spf1 include:_spf.google.com ~all"),
                    ttl=300
                )
            )

        elif qname == "_spf.google.com." and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(
                    qname,
                    QTYPE.TXT,
                    rdata=TXT("v=spf1 ip4:64.233.160.0/19 ~all"),
                    ttl=300
                )
            )

        # ===== DMARC =====
        elif qname == "_dmarc.google.com." and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(
                    qname,
                    QTYPE.TXT,
                    rdata=TXT("v=DMARC1; p=none"),
                    ttl=300
                )
            )

        # ===== DKIM =====
        elif "._domainkey.google.com." in qname and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(
                    qname,
                    QTYPE.TXT,
                    rdata=TXT("v=DKIM1; k=rsa; p=FAKEKEY"),
                    ttl=300
                )
            )

        # ===== MX PARA GOOGLE.COM =====
        elif qname == "google.com." and qtype == QTYPE.MX:
            reply.add_answer(
                RR(
                    qname,
                    QTYPE.MX,
                    rdata=MX("mail.google.com.", 10),
                    ttl=300
                )
            )

        # ===== FORWARD A DNS UPSTREAM =====
        else:
            try:
                sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
                sock.settimeout(3)
                sock.sendto(request.pack(), UPSTREAM_DNS)
                data, _ = sock.recvfrom(4096)
                return DNSRecord.parse(data)

            except Exception:
                reply.header.rcode = RCODE.SERVFAIL

        return reply


if __name__ == "__main__":
    resolver = MyResolver()
    logger = DNSLogger("", False)
    server = DNSServer(
        resolver,
        port=53,
        address="0.0.0.0",
        logger=logger
    )
    server.start()


