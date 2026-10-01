cat > ~/inventario-aircrack.sh <<'EOF'
#!/bin/bash

OK=0
MISS=0

TOOLS="
aircrack-ng
airdecap-ng
airdecloak-ng
airolib-ng
airbase-ng
aireplay-ng
airmon-ng
airodump-ng
airserv-ng
airtun-ng
ivstools
kstats
packetforge-ng
wpaclean
iw
iwconfig
iwlist
rfkill
ethtool
tcpdump
tshark
macchanger
hcxdumptool
hcxpcapngtool
"

echo "======================================"
echo " INVENTARIO AIRCRACK-NG / WIFI"
echo "======================================"

for tool in $TOOLS; do
    if command -v "$tool" >/dev/null 2>&1; then
        printf '[OK]   %-20s %s\n' "$tool" "$(command -v "$tool")"
        OK=$((OK+1))
    else
        printf '[MISS] %-20s\n' "$tool"
        MISS=$((MISS+1))
    fi
done

echo
echo "======================================"
printf 'Disponibles : %s\n' "$OK"
printf 'Faltantes   : %s\n' "$MISS"
echo "======================================"

exit "$MISS"
EOF

chmod +x ~/inventario-aircrack.sh
~/inventario-aircrack.sh