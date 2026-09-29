cat > ~/diagnostico-red.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

echo "========================================"
echo "     DIAGNÓSTICO DE RED - TERMUX"
echo "========================================"

echo
echo "[1] KERNEL / HARDWARE"
echo "----------------------------------------"
uname -a
echo "Arquitectura: $(uname -m)"

echo
echo "[2] INTERFACES"
echo "----------------------------------------"
ip -br addr

echo
echo "[3] RUTA PREDETERMINADA"
echo "----------------------------------------"
ip route | grep -E '^default' || echo "No hay gateway predeterminado"

GW=$(ip route | awk '/^default/ {print $3; exit}')
IFACE=$(ip route | awk '/^default/ {print $5; exit}')

echo "Gateway : ${GW:-No detectado}"
echo "Interfaz: ${IFACE:-No detectada}"

echo
echo "[4] IP DE LA INTERFAZ ACTIVA"
echo "----------------------------------------"

if [ -n "$IFACE" ]; then
    ip -4 addr show "$IFACE" 2>/dev/null |
        awk '/inet / {print "IPv4: " $2}'
    ip -6 addr show "$IFACE" 2>/dev/null |
        awk '/inet6 / {print "IPv6: " $2}'
else
    echo "No se pudo determinar la interfaz."
fi

echo
echo "[5] DNS"
echo "----------------------------------------"
if [ -f /etc/resolv.conf ]; then
    grep -E '^(nameserver|search)' /etc/resolv.conf ||
        echo "No se encontraron servidores DNS."
else
    echo "/etc/resolv.conf no existe."
fi

echo
echo "[6] TIPO DE CONEXIÓN"
echo "----------------------------------------"

WIFI_INFO="$(termux-wifi-connectioninfo 2>/dev/null || true)"

if echo "$WIFI_INFO" | grep -qi '"supplicantState": "COMPLETED"'; then
    echo "Conexión: Wi-Fi"
    echo "$WIFI_INFO" | grep -E '"(ssid|bssid|link_speed_mbps|frequency_mhz)"'
else
    echo "Wi-Fi: no conectado"

    MOBILE_INFO="$(termux-telephony-deviceinfo 2>/dev/null || true)"

    if echo "$MOBILE_INFO" | grep -qiE '5G|NR'; then
        echo "Conexión móvil: 5G / NR"
    elif echo "$MOBILE_INFO" | grep -qiE '4G|LTE'; then
        echo "Conexión móvil: 4G / LTE"
    else
        echo "Conexión móvil: no determinada"
    fi
fi

echo
echo "[7] PRUEBA DE CONECTIVIDAD"
echo "----------------------------------------"

if ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
    echo "Internet: OK"
else
    echo "Internet: SIN RESPUESTA"
fi

if getent hosts google.com >/dev/null 2>&1; then
    echo "DNS: OK"
else
    echo "DNS: FALLA"
fi

echo
echo "[8] RUTA A INTERNET"
echo "----------------------------------------"
ip route get 1.1.1.1 2>/dev/null || echo "No se pudo determinar la ruta."

echo
echo "========================================"
echo "             FIN DEL DIAGNÓSTICO"
echo "========================================"
EOF

chmod +x ~/diagnostico-red.sh
~/diagnostico-red.sh