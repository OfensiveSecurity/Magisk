#!/bin/zsh
echo "=== Scanner en iOS (iPhone) ==="

echo -e "\n[+] Conexiones de red activas en el iPhone:"
# En iOS, 'ss' no suele estar disponible. Usamos 'netstat' o 'lsof' (requiere Darwin Tools)
if command -v netstat &> /dev/null; then
    netstat -an | grep LISTEN
else
    echo "[!] Instala 'Darwin Tools' desde Cydia/Sileo para usar netstat"
fi

echo -e "\n[+] Nota de dependencias:"
echo "Para instalar herramientas en iOS (Jailbreak), usa: Procursus/APT (apt install nmap)"
echo "Si usas la app iSH (Alpine), usa: apk add nmap binwalk curl"

echo -e "\n[+] Nmap a Puertos Comunes de iPhone (Localhost):"
# 22/44: SSH (Dropbear/OpenSSH en Jailbreak)
# 62078: Apple Mobile Device SideSync / Lockdown service
# 5353: mDNS / Bonjour
nmap -Pn -p 22,44,5353,62078 127.0.0.1

# Sección de parsing web (pup no suele venir por defecto, se reemplaza con sed/grep si no existe)
echo -e "\n[+] Extrayendo enlaces de prueba:"
if command -v pup &> /dev/null; then
    curl -s https://example.com | pup 'a attr{href}'
else
    curl -s https://example.com | grep -oE 'href="([^"#]+)"' | cut -d'"' -f2
fi

echo -e "\n[+] Nmap a través de Proxy SOCKS local (si usas Tor/Orbot en iOS):"
# Escaneo de red local usando el puerto por defecto de Orbot/Tor en iOS (normalmente 9050)
sudo nmap -sS -Pn -p 1-1024 --proxy socks4://127.0.0.1:9050 192.168.1.10 2>/dev/null || echo "[!] Ejecuta como root o instala proxychains"

# Persistencia SSH en iOS (Ruta idéntica a Linux, pero el directorio de root suele ser /var/root)
echo -e "\n[+] Configurando llaves SSH autorizadas:"
mkdir -p ~/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZ..." >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

# En iOS no hay Docker nativo. Se simula interactuando con un contenedor remoto si fuera necesario, 
# o simplemente se omite. Aquí se deja comentado o redirigido a una sesión SSH local.
echo -e "\n[-] Docker no es compatible nativamente con iOS. Omitiendo 'docker exec'."

# Análisis de firmware / binarios
if [ -f README.bin ]; then
    echo -e "\n[+] Binwalk (Análisis del archivo):"
    if command -v binwalk &> /dev/null; then
        binwalk README.bin
    else
        echo "[!] binwalk no está instalado."
    fi
else
    echo -e "\n[!] README.bin no encontrado. Buscando recursos alternativos..."
    curl -s https://apple.com | grep -oE 'href="([^"#]+)"' | sort -u | head -n 10
fi
