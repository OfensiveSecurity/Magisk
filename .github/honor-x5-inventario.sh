#!/data/data/com.termux/files/usr/bin/bash

echo "===== HONOR X5 / ANDROID ====="
echo "Fabricante : $(getprop ro.product.manufacturer)"
echo "Modelo     : $(getprop ro.product.model)"
echo "Nombre     : $(getprop ro.product.device)"
echo "Android    : $(getprop ro.build.version.release)"
echo "SDK        : $(getprop ro.build.version.sdk)"
echo "Build      : $(getprop ro.build.display.id)"
echo "SoC        : $(getprop ro.hardware)"
echo "CPU ABI    : $(getprop ro.product.cpu.abilist)"
echo "Bootloader : $(getprop ro.boot.bootloader)"

echo
echo "===== KERNEL ====="
uname -a

echo
echo "===== MEMORIA ====="
free -h

echo
echo "===== ALMACENAMIENTO ====="
df -h "$HOME"

echo
echo "===== TERMUX ====="
termux-info 2>/dev/null || echo "termux-info no disponible"

echo
echo "===== ROOT ====="
if command -v su >/dev/null 2>&1; then
    echo "su encontrado: $(command -v su)"
    su -c id 2>&1
else
    echo "su no disponible"
fi

echo
echo "===== ARQUITECTURA ====="
dpkg --print-architecture 2>/dev/null
uname -m

echo
echo "===== RED ====="
ip addr 2>/dev/null | head -80

echo
echo "===== USB ====="
ls -l /dev/bus/usb 2>/dev/null || true