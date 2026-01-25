#!/bin/bash

# Script para configuración automática de DKIM/SPF
# Script: config_dkin_dns.sh
# Uso: sudo ./config_dkin_dns.sh

# Verificar si se ejecuta como root
if [[ $EUID -ne 0 ]]; then
   echo "Este script debe ejecutarse como root (sudo)"
   echo "Uso: sudo ./configurar_dkim.sh"
   exit 1
fi

# Colores para mejor visualización
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}CONFIGURADOR AUTOMÁTICO DKIM/SPF${NC}"
echo -e "${BLUE}================================================${NC}"

# Solicitar dominio
echo ""
read -p "Introduce tu dominio (ej: midominio.com): " DOMINIO

if [[ -z "$DOMINIO" ]]; then
    echo -e "${RED}Debes especificar un dominio. Saliendo...${NC}"
    exit 1
fi

echo -e "${YELLOW}Configurando DKIM/SPF para: $DOMINIO${NC}"
echo ""

# Menú principal
echo -e "${GREEN}Seleccione la configuración a realizar:${NC}"
echo "1. Configurar DKIM solamente"
echo "2. Configurar SPF solamente"
echo "3. Configurar DKIM y SPF (completo)"
echo "4. Instalar dependencias necesarias"
echo "5. Mostrar información de configuración"
echo "6. Salir"
echo ""

read -p "Opción (1-6): " OPCION

case $OPCION in
    1|3)
        # Configurar DKIM
        echo -e "${YELLOW}Iniciando configuración DKIM...${NC}"

        # Instalar dependencias si es necesario
        if ! command -v opendkim &> /dev/null; then
            echo -e "${YELLOW}Instalando OpenDKIM...${NC}"
            apt-get update
            apt-get install -y opendkim opendkim-tools
        fi

        # Crear directorios
        echo -e "${YELLOW}Creando directorios DKIM...${NC}"
        mkdir -p /etc/opendkim/keys/"$DOMINIO"

        # Generar claves DKIM
        echo -e "${YELLOW}Generando claves DKIM para $DOMINIO...${NC}"
        opendkim-genkey -D /etc/opendkim/keys/"$DOMINIO"/ -d "$DOMINIO" -s default

        # Configurar permisos
        chown -R opendkim:opendkim /etc/opendkim/keys
        chmod 600 /etc/opendkim/keys/"$DOMINIO"/default.private

        # Configurar KeyTable
        echo "default._domainkey.$DOMINIO $DOMINIO:default:/etc/opendkim/keys/$DOMINIO/default.private" > /etc/opendkim/KeyTable

        # Configurar SigningTable
        echo "*@$DOMINIO default._domainkey.$DOMINIO" > /etc/opendkim/SigningTable

        # Configurar TrustedHosts
        echo "127.0.0.1" > /etc/opendkim/TrustedHosts
        echo "localhost" >> /etc/opendkim/TrustedHosts
        echo "$DOMINIO" >> /etc/opendkim/TrustedHosts

        # Configurar OpenDKIM
        cat > /etc/opendkim.conf << EOF
AutoRestart             Yes
AutoRestartRate         10/1h
UMask                   002
Syslog                  yes
SyslogSuccess           Yes
LogWhy                  Yes
Canonicalization        relaxed/simple
ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts
InternalHosts           refile:/etc/opendkim/TrustedHosts
KeyTable                refile:/etc/opendkim/KeyTable
SigningTable            refile:/etc/opendkim/SigningTable
Mode                    sv
PidFile                 /var/run/opendkim/opendkim.pid
SignatureAlgorithm      rsa-sha256
UserID                  opendkim:opendkim
Socket                  inet:8891@localhost
EOF

        # Configurar Postfix para usar DKIM
        echo -e "${YELLOW}Configurando Postfix...${NC}"
        postconf -e "milter_default_action = accept"
        postconf -e "milter_protocol = 6"
        postconf -e "smtpd_milters = inet:localhost:8891"
        postconf -e "non_smtpd_milters = inet:localhost:8891"

        echo -e "${GREEN}✅ Configuración DKIM completada${NC}"

        # Mostrar registro DNS
        echo ""
        echo -e "${BLUE}================================================${NC}"
        echo -e "${BLUE}REGISTRO DNS DKIM PARA TU DOMINIO:${NC}"
        echo -e "${BLUE}================================================${NC}"
        echo "Nombre: default._domainkey.$DOMINIO"
        echo "Tipo: TXT"
        echo "Valor:"
        cat /etc/opendkim/keys/"$DOMINIO"/default.txt | grep -oP '(?<=").*(?=")' | sed 's/\" \"/\n  /g'
        echo ""
        ;;

    2|3)
        # Configurar SPF
        echo -e "${YELLOW}Configurando SPF...${NC}"

        # Obtener IP pública
        IP_PUBLICA=$(curl -s ifconfig.me)

        echo ""
        echo -e "${BLUE}================================================${NC}"
        echo -e "${BLUE}REGISTRO DNS SPF PARA TU DOMINIO:${NC}"
        echo -e "${BLUE}================================================${NC}"
        echo "Nombre: @ (o $DOMINIO)"
        echo "Tipo: TXT"
        echo "Valor: \"v=spf1 a mx ip4:$IP_PUBLICA ~all\""
        echo ""
        echo "Para permitir todos los servidores de tu red:"
        echo "\"v=spf1 a mx ip4:$IP_PUBLICA/24 ~all\""
        echo ""
        ;;

    4)
        # Instalar dependencias
        echo -e "${YELLOW}Instalando dependencias...${NC}"
        apt-get update
        apt-get install -y postfix mailutils opendkim opendkim-tools curl
        echo -e "${GREEN}✅ Dependencias instaladas${NC}"
        ;;

    5)
        # Mostrar información
        echo ""
        echo -e "${BLUE}================================================${NC}"
        echo -e "${BLUE}INFORMACIÓN DE CONFIGURACIÓN${NC}"
        echo -e "${BLUE}================================================${NC}"
        echo ""
        echo -e "${YELLOW}PASOS PARA CONFIGURAR CORREO CON AUTENTICACIÓN:${NC}"
        echo ""
        echo "1. Configurar DKIM:"
        echo "   - Ejecutar: sudo ./configurar_dkim.sh (opción 1 o 3)"
        echo "   - Copiar el registro DKIM a tu DNS"
        echo ""
        echo "2. Configurar SPF:"
        echo "   - Ejecutar: sudo ./configurar_dkim.sh (opción 2 o 3)"
        echo "   - Copiar el registro SPF a tu DNS"
        echo ""
        echo "3. Configurar DMARC (opcional):"
        echo "   Registro DNS TXT:"
        echo "   Nombre: _dmarc.$DOMINIO"
        echo "   Valor: \"v=DMARC1; p=none; rua=mailto:admin@$DOMINIO\""
        echo ""
        echo "4. Reiniciar servicios:"
        echo "   systemctl restart opendkim postfix"
        echo ""
        echo "5. Probar configuración:"
        echo "   ./envio_email.sh"
        echo ""
        ;;

    6)
        echo "Saliendo..."
        exit 0
        ;;

    *)
        echo -e "${RED}Opción no válida${NC}"
        exit 1
        ;;
esac

# Reiniciar servicios si se configuró DKIM
if [[ $OPCION == "1" || $OPCION == "3" ]]; then
    echo ""
    read -p "¿Reiniciar servicios OpenDKIM y Postfix? (s/n): " REINICIAR
    if [[ "$REINICIAR" == "s" || "$REINICIAR" == "S" ]]; then
        systemctl restart opendkim
        systemctl restart postfix
        echo -e "${GREEN}✅ Servicios reiniciados${NC}"
    fi
fi

echo ""
echo -e "${BLUE}================================================${NC}"
echo -e "${GREEN}CONFIGURACIÓN COMPLETADA${NC}"
echo -e "${BLUE}================================================${NC}"
echo ""
echo "Resumen:"
echo "1. Copia los registros DNS mostrados a tu proveedor de dominio"
echo "2. Los cambios DNS pueden tardar hasta 48 horas en propagarse"
echo "3. Para probar el envío: ./envio_email.sh"
echo "4. Para verificar DKIM:"
echo "   opendkim-testkey -d $DOMINIO -s default -vvv"
echo ""
