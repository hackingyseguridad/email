#!/bin/sh
# analizaemail.sh - Analizador forense de cabeceras email
# Compatible con sh / bash antiguos (POSIX)
# hackingyseguridad.com 2026
# @antonio_taboada

FILE="$1"

if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
    echo "Uso: $0 email_headers.txt"
    exit 1
fi

echo "===================================="
echo "      ANALISIS FORENSE DE EMAIL"
echo "===================================="
echo

# -------------------------
# 1. EXTRACCION DE CAMPOS
# -------------------------

FROM_DOMAIN=`grep -i "^From:" "$FILE" | sed 's/.*@//' | tr -d '> ' | head -n 1`
RETURN_DOMAIN=`grep -i "^Return-Path:" "$FILE" | sed 's/.*@//' | tr -d '> ' | head -n 1`

DKIM_DOMAIN=`grep -i "^DKIM-Signature:" "$FILE" \
| sed 's/.* d=//' | cut -d';' -f1 | head -n 1`

# Primera IP externa real (Received más bajo)
SOURCE_IP=`grep -i "^Received:" "$FILE" | tail -n 1 \
| sed 's/.*\[//' | sed 's/\].*//'`

# -------------------------
# 2. SERVIDOR SMTP ORIGEN
# -------------------------

SMTP_SERVER=`grep -i "^Received:" "$FILE" | tail -n 1 \
| sed 's/^Received:[ ]*from[ ]*//' \
| sed 's/[ ]*(.*//' \
| cut -d' ' -f1`

# Fallback formato "by"
if echo "$SMTP_SERVER" | grep -qi "^by$"; then
    SMTP_SERVER=`grep -i "^Received:" "$FILE" | tail -n 1 \
    | sed 's/^Received:[ ]*by[ ]*//' \
    | cut -d' ' -f1`
fi

echo "From domain        : $FROM_DOMAIN"
echo "Return-Path domain : $RETURN_DOMAIN"
echo "DKIM domain        : $DKIM_DOMAIN"
echo "SMTP origen real   : $SMTP_SERVER"
echo "Source IP          : $SOURCE_IP"
echo

# -------------------------
# 3. SPF REAL (OFFLINE)
# -------------------------

SPF_RESULT="FAIL"
SPF_REASON="Sin evidencia SPF"

if grep -iq "SPF_PASS\|SPF: pass" "$FILE"; then
    SPF_RESULT="PASS"
    SPF_REASON="Servidor receptor indica SPF PASS"
fi

if [ "$RETURN_DOMAIN" != "$FROM_DOMAIN" ]; then
    SPF_RESULT="FAIL"
    SPF_REASON="Return-Path no alineado con From"
fi

echo "[SPF ] Resultado : $SPF_RESULT ($SPF_REASON)"

# -------------------------
# 4. DKIM REAL
# -------------------------

DKIM_RESULT="FAIL"
DKIM_REASON="No DKIM"

if [ -n "$DKIM_DOMAIN" ]; then
    DKIM_RESULT="PASS"
    DKIM_REASON="Firma DKIM presente (d=$DKIM_DOMAIN)"
fi

if [ -n "$DKIM_DOMAIN" ] && [ "$DKIM_DOMAIN" != "$FROM_DOMAIN" ]; then
    DKIM_REASON="Firma DKIM presente pero NO alineada"
fi

echo "[DKIM] Resultado : $DKIM_RESULT ($DKIM_REASON)"

# -------------------------
# 5. DMARC REAL
# -------------------------

DMARC_RESULT="FAIL"
DMARC_REASON="SPF y DKIM fallan"

if [ "$SPF_RESULT" = "PASS" ] && [ "$RETURN_DOMAIN" = "$FROM_DOMAIN" ]; then
    DMARC_RESULT="PASS"
    DMARC_REASON="SPF alineado"
fi

if [ "$DKIM_RESULT" = "PASS" ] && [ "$DKIM_DOMAIN" = "$FROM_DOMAIN" ]; then
    DMARC_RESULT="PASS"
    DMARC_REASON="DKIM alineado"
fi

echo "[DMARC] Resultado: $DMARC_RESULT ($DMARC_REASON)"

# -------------------------
# 6. DETECCION DE SPOOFING
# -------------------------

echo
echo "======= POSIBLE FALSIFICACION ======="

SPOOF="NO"

if [ "$FROM_DOMAIN" != "$RETURN_DOMAIN" ]; then
    echo " From ≠ Return-Path"
    SPOOF="SI"
fi

if [ -n "$DKIM_DOMAIN" ] && [ "$DKIM_DOMAIN" != "$FROM_DOMAIN" ]; then
    echo " DKIM no alineado con From"
    SPOOF="SI"
fi

if [ "$SPF_RESULT" = "FAIL" ] && [ "$DKIM_RESULT" = "FAIL" ]; then
    echo " SPF y DKIM fallan simultáneamente"
    SPOOF="SI"
fi

# Servidor SMTP sospechoso
if [ -n "$SMTP_SERVER" ] && [ -n "$FROM_DOMAIN" ]; then
    echo "$SMTP_SERVER" | grep -qi "$FROM_DOMAIN"
    if [ $? -ne 0 ]; then
        echo "-- Servidor SMTP no coincide con dominio From"
        SPOOF="SI"
    fi
fi

if [ "$SPOOF" = "NO" ]; then
    echo "✔ No se detecta falsificación evidente"
else
    echo "-- POSIBLE EMAIL FALSIFICADO"
fi
echo
echo "===================================="
