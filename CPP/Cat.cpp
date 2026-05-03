#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// --- CONFIGURACIÓN ---
#define MODEM_IP "192.168.100.1"
#define USER "root"
#define PASS "admin"

// Define aquí las MACs de tu Motorola, tu Laptop y cualquier equipo seguro
const char* lista_blanca[] = {
    "AA:BB:CC:DD:EE:FF", // Tu Motorola G05
    "11:22:33:44:55:66", // Tu Laptop de estudio
    "00:00:00:00:00:00"  // Espacio para otra MAC
};
int num_seguros = 3;

// Función para verificar si una MAC es conocida
int es_segura(char* mac) {
    for(int i = 0; i < num_seguros; i++) {
        if(strcasecmp(mac, lista_blanca[i]) == 0) return 1;
    }
    return 0;
}

// Función para enviar el baneo al módem vía cURL
void bloquear_en_modem(char* mac_intrusa) {
    char comando[512];
    printf("[!] Alerta: MAC desconocida detectada: %s\n", mac_intrusa);
    
    // Comando POST para el panel de administración
    sprintf(comando, "curl -s -u %s:%s -X POST -d \"filter_mac=%s&action=block\" http://%s/admin/network_filter.cgi", 
            USER, PASS, mac_intrusa, MODEM_IP);
    
    system(comando);
    printf("[+] Comando de bloqueo enviado al módem.\n");
}

int main() {
    FILE *fp;
    char ip[20], hw_type[10], flags[10], mac[20], mask[10], device[10];

    printf("--- Monitor Nexus: Vigilando 192.168.100.1 ---\n");

    fp = fopen("/proc/net/arp", "r");
    if (fp == NULL) return 1;

    // Saltar la cabecera del archivo /proc/net/arp
    char header[256];
    fgets(header, sizeof(header), fp);

    // Leer cada entrada de la tabla ARP
    while (fscanf(fp, "%s %s %s %s %s %s", ip, hw_type, flags, mac, mask, device) != EOF) {
        // Solo procesar si la MAC no es 00:00:00... (entradas vacías)
        if (strcmp(mac, "00:00:00:00:00:00") != 0) {
            if (!es_segura(mac)) {
                bloquear_en_modem(mac);
            } else {
                printf("[OK] Dispositivo seguro: %s (%s)\n", ip, mac);
            }
        }
    }

    fclose(fp);
    return 0;
}
