#!/usr/bin/env python3
from dnslib import *
from dnslib.server import DNSServer, DNSLogger

class MyResolver:
    def resolve(self, request, handler):
        reply = request.reply()
        qname = str(request.q.qname)
        qtype = request.q.qtype

        # Desactivar recursión
        reply.header.ra = 0

        if qname == "google.com." and qtype == QTYPE.A:
            reply.add_answer(
                RR(qname, QTYPE.A, rdata=A("127.0.0.1"), ttl=300)
            )

        elif qname == "google.com." and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=spf1 include:_spf.google.com ~all"),
                   ttl=300)
            )

        elif qname == "_spf.google.com.":
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=spf1 ip4:64.233.160.0/19 ~all"),
                   ttl=300)
            )

        elif qname == "_dmarc.google.com.":
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=DMARC1; p=none"),
                   ttl=300)
            )

        elif "._domainkey.google.com." in qname:
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=DKIM1; k=rsa; p=FAKEKEY"),
                   ttl=300)
            )

        else:
            # 🔥 BLOQUEO TOTAL
            reply.header.rcode = RCODE.NXDOMAIN

        return reply


resolver = MyResolver()
logger = DNSLogger("", False)
server = DNSServer(resolver, port=53, address="0.0.0.0", logger=logger)
server.start()
