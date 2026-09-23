cat > ~/setup_security_lab.sh <<'EOF'
#!/bin/bash

set -e

LAB="$HOME/security-lab"
WEB="$LAB/webapp"
LOG="$LAB/logs"

echo
echo "================================================"
echo "        SECURITY LAB - KALI / NETHUNTER"
echo "================================================"
echo

# ------------------------------------------------
# Comprobaciones
# ------------------------------------------------

if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
else
    if command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        SUDO=""
    fi
fi

echo "[+] Arquitectura:"
uname -m

echo
echo "[+] Sistema:"
cat /etc/os-release 2>/dev/null | grep -E '^(NAME|VERSION)=' || true

# ------------------------------------------------
# Directorios
# ------------------------------------------------

mkdir -p "$LAB"
mkdir -p "$WEB"
mkdir -p "$LOG"

# ------------------------------------------------
# Dependencias
# ------------------------------------------------

echo
echo "[1/8] Actualizando repositorios..."

$SUDO apt-get update

echo
echo "[2/8] Instalando dependencias..."

$SUDO apt-get install -y \
    caido-cli \
    beef-xss \
    set \
    python3 \
    python3-pip \
    python3-venv \
    curl \
    jq \
    git \
    net-tools

# ------------------------------------------------
# Shodan CLI
# ------------------------------------------------

echo
echo "[3/8] Instalando Shodan CLI..."

python3 -m venv "$LAB/shodan-venv"

"$LAB/shodan-venv/bin/pip" install --upgrade pip
"$LAB/shodan-venv/bin/pip" install --upgrade shodan

ln -sf \
    "$LAB/shodan-venv/bin/shodan" \
    "$LAB/shodan"

echo "[OK] Shodan instalado."

# ------------------------------------------------
# Aplicación vulnerable LOCAL
# ------------------------------------------------

echo
echo "[4/8] Creando aplicación vulnerable local..."

cat > "$WEB/app.py" <<'PYEOF'
#!/usr/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse, parse_qs
import html
import time

HOST = "127.0.0.1"
PORT = 8088


PAGE = """
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Security Lab</title>

<style>
body {
    font-family: sans-serif;
    max-width: 850px;
    margin: 40px auto;
    padding: 20px;
}

.box {
    border: 1px solid #aaa;
    padding: 20px;
    margin-top: 20px;
}

input {
    padding: 8px;
    width: 90%;
}

button {
    padding: 8px 15px;
}

.warning {
    background: #fff3cd;
    padding: 12px;
}
</style>

</head>

<body>

<h1>Security Lab</h1>

<div class="warning">
<strong>Laboratorio local.</strong>
Todo el tráfico está limitado a 127.0.0.1.
No introducir credenciales reales.
</div>

<div class="box">

<h2>Reflected XSS Demo</h2>

<form method="GET">

<label>Texto de prueba:</label><br><br>

<input name="q"
       value="{{QUERY}}">

<br><br>

<button type="submit">
Enviar
</button>

</form>

<p>
Resultado:
</p>

<div>
{{RESULT}}
</div>

</div>

<div class="box">

<h2>Prueba JavaScript segura</h2>

<button onclick="labTest()">
Ejecutar prueba
</button>

<p id="output"></p>

<script>

function labTest() {

    document.getElementById("output").innerText =
        "JavaScript ejecutado correctamente en el laboratorio.";

}

</script>

</div>

<div class="box">

<h2>Información</h2>

<p>
Timestamp: {{TIME}}
</p>

<p>
Servidor: 127.0.0.1:8088
</p>

</div>

</body>
</html>
"""


class Handler(BaseHTTPRequestHandler):

    def log_message(self, fmt, *args):

        print(
            "[HTTP]",
            self.client_address[0],
            "-",
            fmt % args
        )

    def do_GET(self):

        parsed = urlparse(self.path)

        params = parse_qs(parsed.query)

        query = params.get("q", [""])[0]

        # Intencionalmente vulnerable:
        # se muestra HTML proporcionado por el usuario.
        #
        # SOLO está disponible en localhost.

        result = query

        page = PAGE

        page = page.replace(
            "{{QUERY}}",
            html.escape(query, quote=True)
        )

        page = page.replace(
            "{{RESULT}}",
            result
        )

        page = page.replace(
            "{{TIME}}",
            time.ctime()
        )

        data = page.encode()

        self.send_response(200)

        self.send_header(
            "Content-Type",
            "text/html; charset=utf-8"
        )

        self.send_header(
            "Content-Length",
            str(len(data))
        )

        self.end_headers()

        self.wfile.write(data)


if __name__ == "__main__":

    print()
    print("========================================")
    print(" SECURITY LAB WEBAPP")
    print("========================================")
    print()
    print("Local URL:")
    print("http://127.0.0.1:8088")
    print()
    print("No escucha en interfaces externas.")
    print()

    HTTPServer(
        (HOST, PORT),
        Handler
    ).serve_forever()
PYEOF

chmod +x "$WEB/app.py"

# ------------------------------------------------
# Página de prueba
# ------------------------------------------------

cat > "$WEB/README.txt" <<'EOF'
SECURITY LAB
============

Aplicación vulnerable deliberadamente.

URL:

http://127.0.0.1:8088

Objetivos:

1. Observar tráfico HTTP con Caido.
2. Identificar el parámetro q.
3. Analizar el XSS reflejado.
4. Observar JavaScript desde el navegador.
5. Utilizar BeEF solamente contra este laboratorio.
6. Practicar reconocimiento Shodan únicamente
   sobre activos propios/autorizados.

NO utilizar credenciales reales.
NO exponer el puerto 8088 a Internet.
EOF

# ------------------------------------------------
# Scripts de arranque
# ------------------------------------------------

echo
echo "[5/8] Creando comandos auxiliares..."

cat > "$LAB/start-web.sh" <<'EOFWEB'
#!/bin/bash

cd "$(dirname "$0")/webapp"

exec python3 app.py
EOFWEB

chmod +x "$LAB/start-web.sh"


cat > "$LAB/start-caido.sh" <<'EOFCAIDO'
#!/bin/bash

echo "Caido local"
echo

exec caido-cli \
    --proxy-listen 127.0.0.1:8080 \
    --ui-listen 127.0.0.1:8081 \
    --no-open
EOFCAIDO

chmod +x "$LAB/start-caido.sh"


cat > "$LAB/start-beef.sh" <<'EOFBEFF'
#!/bin/bash

echo "BeEF"
echo

if command -v beef-xss >/dev/null 2>&1; then
    exec beef-xss
fi

if [ -x /usr/share/beef-xss/beef ]; then
    cd /usr/share/beef-xss
    exec ./beef
fi

echo "[ERROR] No se encontró BeEF."
exit 1
EOFBEFF

chmod +x "$LAB/start-beef.sh"


cat > "$LAB/shodan.sh" <<'EOFSHODAN'
#!/bin/bash

SHODAN="$HOME/security-lab/shodan-venv/bin/shodan"

if [ ! -x "$SHODAN" ]; then
    echo "[ERROR] Shodan CLI no está instalado."
    exit 1
fi

exec "$SHODAN" "$@"
EOFSHODAN

chmod +x "$LAB/shodan.sh"

# ------------------------------------------------
# SET launcher
# ------------------------------------------------

cat > "$LAB/start-set.sh" <<'EOFSET'
#!/bin/bash

if command -v setoolkit >/dev/null 2>&1; then
    exec setoolkit
fi

echo "[ERROR] No se encontró setoolkit."
exit 1
EOFSET

chmod +x "$LAB/start-set.sh"

# ------------------------------------------------
# Información
# ------------------------------------------------

echo
echo "[6/8] Comprobando herramientas..."

echo
echo "--- Shodan ---"
"$LAB/shodan" version || true

echo
echo "--- Caido ---"
caido-cli --version || true

echo
echo "--- BeEF ---"
command -v beef-xss || true

echo
echo "--- SET ---"
command -v setoolkit || true

# ------------------------------------------------
# Crear menú
# ------------------------------------------------

echo
echo "[7/8] Creando menú..."

cat > "$LAB/lab-menu.sh" <<'EOFMENU'
#!/bin/bash

LAB="$HOME/security-lab"

while true
do

    clear

    echo "======================================"
    echo "       SECURITY LAB"
    echo "======================================"
    echo
    echo "1) Aplicación vulnerable"
    echo "2) Caido"
    echo "3) BeEF"
    echo "4) SET"
    echo "5) Shodan CLI"
    echo "6) Estado"
    echo "0) Salir"
    echo

    read -r -p "Selecciona: " OP

    case "$OP" in

        1)
            "$LAB/start-web.sh"
            ;;

        2)
            "$LAB/start-caido.sh"
            ;;

        3)
            "$LAB/start-beef.sh"
            ;;

        4)
            "$LAB/start-set.sh"
            ;;

        5)
            echo
            echo "Ejemplo:"
            echo
            echo "  $LAB/shodan.sh version"
            echo
            echo "Inicialización:"
            echo
            echo "  $LAB/shodan.sh init TU_API_KEY"
            echo
            read -r -p "ENTER para continuar..."
            ;;

        6)
            echo
            echo "Web:"
            curl -s -o /dev/null \
                -w "HTTP: %{http_code}\n" \
                http://127.0.0.1:8088 \
                || echo "Web detenida."

            echo
            echo "Caido:"
            pgrep -af caido-cli || echo "Caido detenido."

            echo
            echo "BeEF:"
            pgrep -af beef || echo "BeEF detenido."

            echo
            echo "SET:"
            pgrep -af setoolkit || true

            echo
            read -r -p "ENTER para continuar..."
            ;;

        0)
            exit 0
            ;;

        *)
            echo "Opción inválida."
            sleep 1
            ;;

    esac

done
EOFMENU

chmod +x "$LAB/lab-menu.sh"

# ------------------------------------------------
# Resumen
# ------------------------------------------------

echo
echo "[8/8] Instalación terminada."

echo
echo "================================================"
echo " LABORATORIO LISTO"
echo "================================================"
echo
echo "Directorio:"
echo "  $LAB"
echo
echo "Aplicación:"
echo "  $LAB/start-web.sh"
echo
echo "Caido:"
echo "  $LAB/start-caido.sh"
echo
echo "BeEF:"
echo "  $LAB/start-beef.sh"
echo
echo "SET:"
echo "  $LAB/start-set.sh"
echo
echo "Shodan:"
echo "  $LAB/shodan.sh"
echo
echo "Menú:"
echo "  $LAB/lab-menu.sh"
echo
echo "================================================"
echo " IMPORTANTE"
echo "================================================"
echo
echo "La aplicación vulnerable escucha SOLO:"
echo
echo "  127.0.0.1:8088"
echo
echo "No expongas este laboratorio a Internet."
echo
EOF

chmod +x ~/setup_security_lab.sh
~/setup_security_lab.sh