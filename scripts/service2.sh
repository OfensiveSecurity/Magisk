#!/system/bin/sh
# Nexus Universal Compatibility Script

# --- OPTIMIZACIÓN DE HARDWARE ---
# Habilitar renderizado forzado por GPU (Mejora el rendimiento de OpenCL)
setprop debug.hwui.renderer opengl
setprop persist.sys.composition.type gpu

# --- SOPORTE DE RED Y AUDITORÍA ---
# Habilitar el reenvío de paquetes (Necesario para ataques de red)
echo 1 > /proc/sys/net/ipv4/ip_forward

# Eliminar restricciones de permisos sobre dispositivos USB (OTG)
# Esto permite que Nexus_Full detecte antenas Alfa o TP-Link
chmod 777 /dev/bus/usb/*/*
chmod 666 /dev/rfkill

# --- COMPATIBILIDAD CON KERNEL ---
# Intentar desactivar SELinux (Modo Permisivo)
# ¡OJO! Esto es necesario para que libpcap pueda acceder al hardware WiFi
setenforce 0

# Aumentar el límite de archivos abiertos (Evita crashes en escaneos masivos)
ulimit -n 65535
