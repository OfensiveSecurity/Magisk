#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h> // Para el registro de fecha y hora

#define MODEM_IP "192.168.100.1"
#define USER "root"
#define PASS "admin"
#define LOG_FILE "nexus_audit.log"

const char* lista_blanca[] = {
    "AA:BB:CC:DD:EE:FF", // Tu Motorola
    "11:22:33:44:55:66"  // Tu Laptop
};
int num_seguros = 2;

// Función para escribir en el archivo LOG
void registrar_evento(char* mensaje, char* mac) {
    FILE *log_fp = fopen(LOG_FILE, "a");
    if (log_fp == NULL) return;

    time_t now;
    time(&now);
    char *fecha = ctime(&now);
    fecha[strlen(fecha) - 1] = '\0'; // Quitar el salto de línea de ctime

    fprintf(log_fp, "[%s] %s: %s\n", fecha, mensaje, mac);
    fclose(log_fp);
}

int es_segura(char* mac) {
    for(int i = 0; i < num_seguros; i++) {
        if(strcasecmp(mac, lista_blanca[i]) == 0) return 1;
    }
    return 0;
}

void monitorear() {
    FILE *fp;
    char ip[20], hw_type[10], flags[10], mac[20], mask[10], device[10];

    fp = fopen("/proc/net/arp", "r");
    if (fp == NULL) return;

    char header
