// bridge_filter.c - FILTRO DE TRÁFICO PÚBLICO
#include <stdio.h>

void filter_packet(char* packet_data) {
    // Si el paquete contiene el prefijo de nuestras llaves B32, es legítimo
    if (strstr(packet_data, "NEXUS_B32_") != NULL) {
        printf("[🔑] COMANDO CRÍPTICO DETECTADO. DERIVANDO A NÚCLEO.\n");
        // Enviar a Python para descifrado X25519
    } else {
        // Tráfico público normal -> Enviar al HoneyPot
        printf("[👤] TRÁFICO PÚBLICO DETECTADO. LOGUEANDO METADATOS.\n");
    }
}
