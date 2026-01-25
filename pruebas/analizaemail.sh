#!/bin/bash

# Script para analizar cabeceras de email .eml
# Compatible con Bash 1.0.x

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "================================================"
    echo "ANALIZADOR DE CABECERAS DE EMAIL (.eml)"
    echo "================================================"
    echo ""
    echo "Este script analiza:"
    echo "  - Origen y autenticidad del correo"
    echo "  - Validaciones SPF, DKIM y DMARC"
    echo "  - Direcciones IP de origen"
    echo "  - Hashes de archivos adjuntos"
    echo ""
}

# Función para verificar si el archivo existe
verificar_archivo() {
    if [ ! -f "$1" ]; then
        echo "Error: El archivo '$1' no existe."
        exit 1
    fi

    if [ ! -r "$1" ]; then
        echo "Error: No se puede leer el archivo '$1'."
        exit 1
    fi
}

# Función para extraer cabeceras
extraer_cabeceras() {
    echo "================================================"
    echo "CABECERAS DEL EMAIL"
    echo "================================================"

    # Extraer cabeceras principales
    echo ""
    echo "1. CABECERAS PRINCIPALES:"
    echo "--------------------------"
    grep -i "^From:" "$archivo" | head -5
    grep -i "^To:" "$archivo" | head -5
    grep -i "^Subject:" "$archivo" | head -5
    grep -i "^Date:" "$archivo" | head -5
    grep -i "^Message-ID:" "$archivo" | head -5

    echo ""
    echo "2. CABECERAS DE ENRUTAMIENTO:"
    echo "------------------------------"
    grep -i "^Received:" "$archivo" | head -10

    echo ""
    echo "3. CABECERAS DE AUTENTICACIÓN:"
    echo "------------------------------"
    grep -i "^Authentication-Results:" "$archivo" | head -10
    grep -i "^Received-SPF:" "$archivo" | head -5
    grep -i "^DKIM-Signature:" "$archivo" | head -5
    grep -i "^DMARC-Validation:" "$archivo" | head -5
}

# Función para analizar IPs de origen
analizar_ips() {
    echo ""
    echo "================================================"
    echo "ANÁLISIS DE DIRECCIONES IP"
    echo "================================================"

    # Extraer IPs de las cabeceras Received
    echo "IPs encontradas en cabeceras Received:"
    echo "--------------------------------------"

    # Buscar IPs en formato IPv4
    grep -i "^Received:" "$archivo" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | sort -u | while read ip; do
        echo "  IP: $ip"
    done

    # Buscar hosts en cabeceras Received
    echo ""
    echo "Hosts encontrados:"
    echo "------------------"
    grep -i "^Received:" "$archivo" | grep -oE "from\s+[^[]+" | sed 's/from\s*//i' | sort -u | while read host; do
        echo "  Host: $host"
    done
}

# Función para verificar autenticación
verificar_autenticacion() {
    echo ""
    echo "================================================"
    echo "VERIFICACIÓN DE AUTENTICIDAD"
    echo "================================================"

    # Verificar SPF
    echo "1. VERIFICACIÓN SPF:"
    echo "--------------------"
    spf_result=$(grep -i "^Received-SPF:" "$archivo" | head -1)
    if [ -n "$spf_result" ]; then
        echo "   Resultado SPF encontrado:"
        echo "   $spf_result"

        # Analizar resultado SPF
        if echo "$spf_result" | grep -qi "pass"; then
            echo "   ✓ SPF: PASS (Verificación correcta)"
        elif echo "$spf_result" | grep -qi "fail"; then
            echo "   ✗ SPF: FAIL (Fallo en verificación)"
        elif echo "$spf_result" | grep -qi "softfail"; then
            echo "   ~ SPF: SOFTFAIL (Fallo suave)"
        elif echo "$spf_result" | grep -qi "neutral"; then
            echo "   ○ SPF: NEUTRAL (Neutral)"
        else
            echo "   ? SPF: Resultado desconocido"
        fi
    else
        echo "   No se encontraron cabeceras Received-SPF"
    fi

    # Verificar DKIM
    echo ""
    echo "2. VERIFICACIÓN DKIM:"
    echo "---------------------"
    dkim_result=$(grep -i "^Authentication-Results:" "$archivo" | grep -i "dkim=" | head -1)
    if [ -n "$dkim_result" ]; then
        echo "   Resultado DKIM encontrado:"
        echo "   $dkim_result"

        if echo "$dkim_result" | grep -qi "dkim=pass"; then
            echo "   ✓ DKIM: PASS (Firma válida)"
        elif echo "$dkim_result" | grep -qi "dkim=fail"; then
            echo "   ✗ DKIM: FAIL (Firma inválida)"
        else
            echo "   ? DKIM: Resultado desconocido"
        fi
    else
        echo "   No se encontraron resultados DKIM en Authentication-Results"
    fi

    # Verificar si existe cabecera DKIM-Signature
    dkim_sig=$(grep -i "^DKIM-Signature:" "$archivo" | head -1)
    if [ -n "$dkim_sig" ]; then
        echo "   Se encontró cabecera DKIM-Signature"
    fi

    # Verificar DMARC
    echo ""
    echo "3. VERIFICACIÓN DMARC:"
    echo "----------------------"
    dmarc_result=$(grep -i "^Authentication-Results:" "$archivo" | grep -i "dmarc=" | head -1)
    if [ -n "$dmarc_result" ]; then
        echo "   Resultado DMARC encontrado:"
        echo "   $dmarc_result"

        if echo "$dmarc_result" | grep -qi "dmarc=pass"; then
            echo "   ✓ DMARC: PASS (Verificación correcta)"
        elif echo "$dmarc_result" | grep -qi "dmarc=fail"; then
            echo "   ✗ DMARC: FAIL (Fallo en verificación)"
        else
            echo "   ? DMARC: Resultado desconocido"
        fi
    else
        echo "   No se encontraron resultados DMARC en Authentication-Results"
    fi
}

# Función para extraer y analizar adjuntos
analizar_adjuntos() {
    echo ""
    echo "================================================"
    echo "ANÁLISIS DE ARCHIVOS ADJUNTOS"
    echo "================================================"

    # Verificar si hay contenido MIME
    if grep -qi "^Content-Type: multipart/mixed" "$archivo" || \
       grep -qi "^Content-Type: multipart/related" "$archivo"; then
        echo "Se detectó correo con archivos adjuntos (MIME)"

        # Crear directorio temporal para extraer adjuntos
        temp_dir="/tmp/email_analysis_$$"
        mkdir -p "$temp_dir"

        # Extraer secciones MIME
        echo ""
        echo "Estructura MIME encontrada:"
        echo "---------------------------"

        # Contar partes MIME
        mime_count=$(grep -c "^Content-Type:" "$archivo")
        echo "Número de partes MIME: $mime_count"

        # Buscar adjuntos
        echo ""
        echo "Buscando archivos adjuntos..."

        # Extraer nombres de archivos adjuntos
        grep -i "^Content-Disposition: attachment" "$archivo" -A 2 -B 2 | grep -i "filename=" | sed 's/.*filename=//i' | tr -d '";' | while read filename; do
            if [ -n "$filename" ]; then
                echo "  ▷ Adjunto encontrado: $filename"
            fi
        done

        # También buscar en Content-Type
        grep -i "^Content-Type:" "$archivo" | grep -i "name=" | sed 's/.*name=//i' | tr -d '";' | while read filename; do
            if [ -n "$filename" ]; then
                echo "  ▷ Adjunto encontrado: $filename"
            fi
        done

        # Extraer y calcular hashes de partes binarias
        echo ""
        echo "Calculando hashes de contenido binario..."
        echo "-----------------------------------------"

        # Usar awk para extraer contenido entre límites MIME
        awk '
        BEGIN {
            boundary = "";
            in_body = 0;
            part_count = 0;
        }
        /^Content-Type:.*boundary=/ {
            match($0, /boundary="?([^"]+)"?/, arr);
            boundary = arr[1];
        }
        /^--/ && boundary && $0 ~ boundary {
            in_body = !in_body;
            if (!in_body) {
                part_count++;
                if (part_content != "") {
                    # Calcular hashes
                    cmd = "echo \"" part_content "\" | md5sum | cut -d\" \" -f1";
                    cmd | getline md5;
                    close(cmd);

                    cmd = "echo \"" part_content "\" | sha1sum | cut -d\" \" -f1";
                    cmd | getline sha1;
                    close(cmd);

                    cmd = "echo \"" part_content "\" | sha256sum | cut -d\" \" -f1";
                    cmd | getline sha256;
                    close(cmd);

                    print "Parte MIME #" part_count ":";
                    print "  MD5:    " md5;
                    print "  SHA1:   " sha1;
                    print "  SHA256: " sha256;
                    print "";
                }
                part_content = "";
            }
            next;
        }
        in_body && $0 !~ /^--/ {
            part_content = part_content $0 "\n";
        }
        ' "$archivo" > "$temp_dir/hashes.txt"

        if [ -s "$temp_dir/hashes.txt" ]; then
            cat "$temp_dir/hashes.txt"
        else
            echo "No se pudo extraer contenido para calcular hashes"
        fi

        # Limpiar directorio temporal
        rm -rf "$temp_dir"

    else
        echo "No se detectaron archivos adjuntos MIME"

        # Calcular hash del cuerpo completo del mensaje
        echo ""
        echo "Calculando hashes del archivo completo:"
        echo "---------------------------------------"

        # MD5
        md5_hash=$(md5sum "$archivo" 2>/dev/null | cut -d' ' -f1)
        if [ -n "$md5_hash" ]; then
            echo "  MD5:    $md5_hash"
        else
            echo "  MD5:    No disponible (comando md5sum no encontrado)"
        fi

        # SHA1
        sha1_hash=$(sha1sum "$archivo" 2>/dev/null | cut -d' ' -f1)
        if [ -n "$sha1_hash" ]; then
            echo "  SHA1:   $sha1_hash"
        else
            echo "  SHA1:   No disponible (comando sha1sum no encontrado)"
        fi

        # SHA256
        sha256_hash=$(sha256sum "$archivo" 2>/dev/null | cut -d' ' -f1)
        if [ -n "$sha256_hash" ]; then
            echo "  SHA256: $sha256_hash"
        else
            echo "  SHA256: No disponible (comando sha256sum no encontrado)"
        fi
    fi
}

# Función para resumen
mostrar_resumen() {
    echo ""
    echo "================================================"
    echo "RESUMEN DEL ANÁLISIS"
    echo "================================================"

    # Evaluar seguridad
    echo "Evaluación de seguridad:"
    echo "-----------------------"

    spf_status="DESCONOCIDO"
    dkim_status="DESCONOCIDO"
    dmarc_status="DESCONOCIDO"

    # Evaluar SPF
    if grep -qi "^Received-SPF:" "$archivo" && grep -i "^Received-SPF:" "$archivo" | grep -qi "pass"; then
        spf_status="PASS"
    elif grep -qi "^Received-SPF:" "$archivo" && grep -i "^Received-SPF:" "$archivo" | grep -qi "fail"; then
        spf_status="FAIL"
    fi

    # Evaluar DKIM
    if grep -qi "^Authentication-Results:" "$archivo" | grep -i "dkim=pass" "$archivo"; then
        dkim_status="PASS"
    elif grep -qi "^Authentication-Results:" "$archivo" | grep -i "dkim=fail" "$archivo"; then
        dkim_status="FAIL"
    fi

    # Evaluar DMARC
    if grep -qi "^Authentication-Results:" "$archivo" | grep -i "dmarc=pass" "$archivo"; then
        dmarc_status="PASS"
    elif grep -qi "^Authentication-Results:" "$archivo" | grep -i "dmarc=fail" "$archivo"; then
        dmarc_status="FAIL"
    fi

    echo "  SPF:    $spf_status"
    echo "  DKIM:   $dkim_status"
    echo "  DMARC:  $dmarc_status"

    # Recomendación
    echo ""
    echo "Recomendación:"
    echo "-------------"

    if [ "$spf_status" = "PASS" ] && [ "$dkim_status" = "PASS" ] && [ "$dmarc_status" = "PASS" ]; then
        echo "✓ El correo parece AUTÉNTICO y VERIFICADO"
        echo "  Las tres verificaciones (SPF, DKIM, DMARC) pasaron"
    elif [ "$spf_status" = "FAIL" ] || [ "$dkim_status" = "FAIL" ] || [ "$dmarc_status" = "FAIL" ]; then
        echo "✗ ADVERTENCIA: El correo podría NO SER AUTÉNTICO"
        echo "  Una o más verificaciones fallaron"
    else
        echo "~ El estado de autenticación es INDETERMINADO"
        echo "  Se recomienda verificación manual"
    fi
}

# Programa principal
clear

# Mostrar ayuda
mostrar_ayuda

# Solicitar archivo
echo -n "Introduce el nombre del archivo .eml: "
read archivo

# Verificar archivo
verificar_archivo "$archivo"

echo ""
echo "Analizando archivo: $archivo"
echo "Tamaño: $(wc -l < "$archivo") líneas"
echo ""

# Ejecutar análisis
extraer_cabeceras
analizar_ips
verificar_autenticacion
analizar_adjuntos
mostrar_resumen

echo ""
echo "================================================"
echo "ANÁLISIS COMPLETADO"
echo "================================================"
