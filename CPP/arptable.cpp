#include <stdio.h>

void leer_tabla_arp() {
    FILE *fp;
    char linea[256];

    fp = fopen("/proc/net/arp", "r");
    if (fp == NULL) {
        perror("Error al abrir /proc/net/arp");
        return;
    }

    printf("\nIP Address\tHW Type\tFlags\tHW Address\tDevice\n");
    while (fgets(linea, sizeof(linea), fp)) {
        printf("%s", linea);
    }

    fclose(fp);
}
