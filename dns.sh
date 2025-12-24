#!/bin/bash

# 1. Desproteger de escritura y borrado
echo "Desprotegiendo /etc/resolv.conf..."
chattr -i -V /etc/resolv.conf

# 2. Guardar los nameservers en el fichero /etc/resolv.conf
echo "Configurando nameservers en /etc/resolv.conf..."
cat > /etc/resolv.conf << 'EOF'
nameserver 80.58.61.250
nameserver 80.58.61.254
nameserver 213.0.184.85
nameserver 213.0.184.88
nameserver 2a02:9000::aaaa
nameserver 2a02:9000::bbbb
EOF

# 3. Proteger de escritura y borrado
echo "Protegiendo /etc/resolv.conf..."
chattr +i -V /etc/resolv.conf

echo "Operación completada."




cat /etc/resolv.conf


