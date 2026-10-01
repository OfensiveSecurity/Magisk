```bash
cat > "$HOME/cpp-analyzer" <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

# ============================================================
# C++ ANALYZER - Termux
# Enfocado en diagnóstico educativo de C++
# ============================================================

set -u

VERSION="0.1.0"

RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'
WHITE='\033[37m'
RESET='\033[0m'

REPORT_DIR="$HOME/cpp-analyzer-data"
REPORT_FILE="$REPORT_DIR/diagnostics.jsonl"

mkdir -p "$REPORT_DIR"

usage() {
    echo
    echo "C++ Analyzer $VERSION"
    echo
    echo "Uso:"
    echo "  cpp-analyzer archivo.cpp"
    echo
    echo "Ejemplo:"
    echo "  cpp-analyzer ramnh.cpp"
    echo
}

timestamp() {
    date -Iseconds
}

json_escape() {
    printf '%s' "$1" | sed \
        -e 's/\\/\\\\/g' \
        -e 's/"/\\"/g' \
        -e ':a;N;$!ba;s/\n/\\n/g'
}

save_record() {
    local file="$1"
    local line="$2"
    local kind="$3"
    local message="$4"
    local hypothesis="$5"
    local verified="$6"

    printf '{"timestamp":"%s","language":"cpp","file":"%s","line":"%s","kind":"%s","message":"%s","hypothesis":"%s","verified":"%s"}\n' \
        "$(timestamp)" \
        "$(json_escape "$file")" \
        "$(json_escape "$line")" \
        "$(json_escape "$kind")" \
        "$(json_escape "$message")" \
        "$(json_escape "$hypothesis")" \
        "$(json_escape "$verified")" \
        >> "$REPORT_FILE"
}

explain_error() {
    local line="$1"
    local msg="$2"

    echo
    echo -e "${RED}❌ HECHO${RESET}"
    echo "El compilador rechazó el código."

    echo
    echo -e "${CYAN}📍 UBICACIÓN${RESET}"
    echo "$line"

    echo
    echo -e "${CYAN}🔎 MENSAJE DEL COMPILADOR${RESET}"
    echo "$msg"

    local hypothesis=""

    case "$msg" in

        *"use of undeclared identifier"*)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "El identificador usado no tiene una declaración visible."
            echo
            echo "Posibles causas:"
            echo "  - falta un #include"
            echo "  - falta una declaración"
            echo "  - un #ifdef excluyó la declaración"
            echo "  - namespace incorrecto"
            echo "  - API no disponible para este target"

            hypothesis="falta_declaracion_o_include"
            ;;

        *"file not found"*)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "No se encontró un archivo de cabecera."
            echo
            echo "Revisar:"
            echo "  - ruta del include"
            echo "  - paquete instalado"
            echo "  - -I"
            echo "  - SDK/NDK"
            echo "  - arquitectura"

            hypothesis="header_no_encontrado"
            ;;

        *"no member named"*)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "El tipo existe, pero el miembro solicitado no está disponible con ese nombre o contexto."

            hypothesis="miembro_no_existente"
            ;;

        *"no matching function"*)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "Los argumentos proporcionados no coinciden con una función disponible."

            hypothesis="argumentos_no_coinciden"
            ;;

        *"invalid conversion"*)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "Existe una conversión de tipos que C++ no permite implícitamente."

            hypothesis="conversion_invalida"
            ;;

        *"undefined reference"*)
            echo
            echo -e "${MAGENTA}❌ LINKER${RESET}"
            echo "El compilador ya pasó la fase de compilación."
            echo "Ahora falta resolver un símbolo durante el enlazado."

            hypothesis="problema_de_linker"
            ;;

        *"expected"*)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "Puede existir un error sintáctico cerca de esta línea."

            hypothesis="error_sintactico"
            ;;

        *)
            echo
            echo -e "${YELLOW}❓ HIPÓTESIS${RESET}"
            echo "No tengo suficiente evidencia para afirmar todavía la causa."

            hypothesis="causa_no_determinada"
            ;;
    esac

    echo
    echo -e "${BLUE}🧪 VERIFICACIÓN${RESET}"

    case "$hypothesis" in
        falta_declaracion_o_include)
            echo "Busca primero la declaración o el include correspondiente."
            echo
            echo "Ejemplo:"
            echo "  grep -n '#include' \"$FILE\""
            ;;

        header_no_encontrado)
            echo "Comprueba que el header realmente existe."
            ;;

        problema_de_linker)
            echo "Revisa las bibliotecas pasadas al enlazador."
            ;;

        *)
            echo "Revisa el contexto alrededor de la línea indicada."
            ;;
    esac

    echo
    echo -e "${WHITE}¿La hipótesis '$hypothesis' es verdadera?${RESET}"
    printf "[s]í / [n]o / [d]esconocido: "

    read -r answer

    case "$answer" in
        s|S|si|SI|sí|Sí)
            verified="true"
            ;;
        n|N|no|NO)
            verified="false"
            ;;
        *)
            verified="unknown"
            ;;
    esac

    save_record "$FILE" "$line" "error" "$msg" "$hypothesis" "$verified"

    echo
    echo -e "${CYAN}📚 Registro guardado:${RESET}"
    echo "$REPORT_FILE"
}

if [ "$#" -ne 1 ]; then
    usage
    exit 2
fi

FILE="$1"

if [ ! -f "$FILE" ]; then
    echo -e "${RED}ERROR:${RESET} archivo no encontrado:"
    echo "$FILE"
    exit 2
fi

if ! command -v clang++ >/dev/null 2>&1; then
    echo -e "${RED}ERROR:${RESET} clang++ no está instalado."
    echo
    echo "Instala:"
    echo "  pkg install clang"
    exit 127
fi

echo
echo -e "${CYAN}========================================${RESET}"
echo -e "${CYAN}        C++ ANALYZER $VERSION${RESET}"
echo -e "${CYAN}========================================${RESET}"
echo
echo "Archivo : $FILE"
echo "Clang   : $(clang++ --version | head -1)"
echo

echo -e "${WHITE}🔎 Analizando...${RESET}"

TMP="$(mktemp)"

clang++ \
    -std=c++20 \
    -Wall \
    -Wextra \
    -fsyntax-only \
    "$FILE" > /dev/null 2> "$TMP"

STATUS=$?

if [ "$STATUS" -eq 0 ]; then
    echo
    echo -e "${GREEN}🟢 CÓDIGO ACEPTADO POR EL COMPILADOR${RESET}"
    echo
    echo "No se encontraron errores de sintaxis/tipos durante esta comprobación."
    echo
    echo "IMPORTANTE:"
    echo "Esto NO demuestra que el programa funcione correctamente en ejecución."
    echo
    rm -f "$TMP"
    exit 0
fi

echo
echo -e "${RED}🔴 ERROR DE COMPILACIÓN${RESET}"
echo

cat "$TMP"

echo
echo -e "${CYAN}========================================${RESET}"
echo -e "${CYAN}        ANÁLISIS EDUCATIVO${RESET}"
echo -e "${CYAN}========================================${RESET}"

while IFS= read -r line; do

    if printf '%s' "$line" | grep -qE ':[0-9]+:[0-9]+: error:'; then

        location="$(printf '%s' "$line" | sed -nE 's/^([^:]+:[0-9]+:[0-9]+): error:.*$/\1/p')"

        message="$(printf '%s' "$line" | sed -E 's/^[^:]+:[0-9]+:[0-9]+: error: //')"

        explain_error "$location" "$message"

    elif printf '%s' "$line" | grep -qE ':[0-9]+:[0-9]+: warning:'; then

        echo
        echo -e "${YELLOW}🟠 WARNING${RESET}"
        echo "$line"

        save_record \
            "$FILE" \
            "unknown" \
            "warning" \
            "$line" \
            "" \
            "unknown"

    fi

done < "$TMP"

rm -f "$TMP"

echo
echo -e "${RED}Resultado final: ERROR${RESET}"
echo "Código de salida: $STATUS"

exit "$STATUS"
EOF

chmod +x "$HOME/cpp-analyzer"
ln -sf "$HOME/cpp-analyzer" "$PREFIX/bin/cpp-analyzer"
```
