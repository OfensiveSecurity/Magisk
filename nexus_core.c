#include <iostream>
#include <cstdlib>

void force_nethunter_update() {
    std::cout << "[*] Aplicando parche de modulos via cat...\n";

    // 1. Creamos el script de inicio forzado
    // Esto vincula los binarios necesarios incluso si la app no los ve
    system("cat << 'EOF' > /data/local/tmp/nh_fix.sh\n"
           "#!/system/bin/sh\n"
           "mount -o remount,rw /system 2>/dev/null\n"
           "BB=/data/adb/magisk/busybox\n"
           "ln -sf $BB /system/xbin/busybox\n"
           "ln -sf $BB /system/bin/busybox\n"
           "chmod 755 /data/local/nhsystem/modules/*\n"
           "echo '[NEXUS] Modulos desbloqueados y BusyBox vinculado.'\n"
           "EOF");

    // 2. Ejecutar con privilegios de Magisk para que surta efecto
    if (system("su -c sh /data/local/tmp/nh_fix.sh") == 0) {
        std::cout << "\033[1;32m[+] Actualizacion completada. Reinicia la App de NetHunter.\033[0m\n";
    } else {
        std::cout << "\033[1;31m[!] Error: Fallo en la inyeccion. Verifica Magisk.\033[0m\n";
    }
}
