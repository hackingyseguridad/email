
#!/bin/bash

# Script simplificado para verificar vulnerabilidades DMARC
# Compatible con Bash antiguo

help() {
    echo "Uso: $0 [OPCION]"
    echo ""
    echo "Opciones:"
    echo "  -d DOMINIO    Verificar un solo dominio"
    echo "  -f ARCHIVO    Verificar múltiples dominios desde un archivo"
    echo ""
    echo "Ejemplos:"
    echo "  $0 -d ejemplo.com"
    echo "  $0 -f dominios.txt"
}

check_url() {
    domain="$1"
    retval=0

    # Verificar registro DMARC usando nslookup
    output=$(nslookup -type=txt _dmarc."$domain" 2>/dev/null)

    if echo "$output" | grep -q "p=reject"; then
        echo "$domain: NO vulnerable"
    elif echo "$output" | grep -q "p=quarantine"; then
        echo "$domain: Puede ser vulnerable (correo a spam)"
    elif echo "$output" | grep -q "p=none"; then
        echo "$domain: VULNERABLE"
        retval=1
    else
        echo "$domain: VULNERABLE (sin registro DMARC)"
        retval=1
    fi

    return $retval
}

check_file() {
    input="$1"
    COUNTER=0
    VULNERABLES=0

    while read -r line || [ -n "$line" ]; do
        # Saltar líneas vacías
        [ -z "$line" ] && continue

        COUNTER=$((COUNTER + 1))
        check_url "$line"
        VULNERABLES=$((VULNERABLES + $?))
    done < "$input"

    echo ""
    echo "Resumen: $VULNERABLES de $COUNTER dominios son vulnerables"
}

main() {
    # Mostrar banner
    echo "========================================="
    echo "    Verificador DMARC - SpoofThatMail"
    echo "    Versión simplificada"
    echo "========================================="
    echo ""

    # Verificar argumentos
    if [ $# -ne 2 ]; then
        echo "Error: Número incorrecto de argumentos"
        help
        exit 1
    fi

    # Procesar opciones
    case "$1" in
        -d)
            if [ -n "$2" ]; then
                check_url "$2"
            else
                echo "Error: Dominio no especificado"
                help
                exit 1
            fi
            ;;
        -f)
            if [ -f "$2" ]; then
                check_file "$2"
            else
                echo "Error: Archivo '$2' no encontrado"
                exit 1
            fi
            ;;
        *)
            echo "Error: Opción inválida"
            help
            exit 1
            ;;
    esac
}

# Ejecutar script principal
main "$@"

