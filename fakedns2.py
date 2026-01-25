#!/usr/bin/env python3
from dnslib import *
from dnslib.server import DNSServer, DNSLogger

class LocalOnlyResolver:
    def resolve(self, request, handler):
        reply = request.reply()
        qname = str(request.q.qname)
        qtype = request.q.qtype

        # ❌ No recursión
        reply.header.ra = 0

        # ====== REGISTROS DEFINIDOS ======

        if qname == "google.com." and qtype in (QTYPE.A, QTYPE.AAAA):
            reply.add_answer(
                RR(qname, QTYPE.A, rdata=A("127.0.0.1"), ttl=300)
            )

        elif qname == "mail.google.com." and qtype in (QTYPE.A, QTYPE.MX):
            reply.add_answer(
                RR(qname, QTYPE.A, rdata=A("127.0.0.1"), ttl=300)
            )
            reply.add_answer(
                RR(qname, QTYPE.MX, rdata=MX("mail.google.com.", 10), ttl=300)
            )

        elif qname == "_spf.google.com." and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=spf1 ip4:127.01 ~all"),
                   ttl=300)
            )

        elif qname == "_dmarc.google.com." and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=DMARC1; p=none"),
                   ttl=300)
            )

        elif "._domainkey.google.com." in qname and qtype == QTYPE.TXT:
            reply.add_answer(
                RR(qname, QTYPE.TXT,
                   rdata=TXT("v=DKIM1; k=rsa; p=FAKEKEY"),
                   ttl=300)
            )

        # ====== TODO LO DEMÁS ======
        else:
            reply.header.rcode = RCODE.NXDOMAIN

        return reply


resolver = LocalOnlyResolver()
logger = DNSLogger("", False)
server = DNSServer(resolver, address="0.0.0.0", port=53, logger=logger)
server.start()
