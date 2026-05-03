#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h> // Para sleep()

#define MODEM_IP "192.168.100.1"
#define USER "root"
#define PASS "admin"

const char* lista_blanca[] = {
    "AA:BB:CC:DD:EE:FF", // Tu Motorola
    "11:22:33:44:55:66"  // Tu Laptop
};
int num_seguros = 2;

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

    char header[256];
    fgets(header, sizeof(header), fp);

    while (fscanf(fp, "%s %s %s %s %s %s", ip, hw_type, flags, mac, mask, device) != EOF) {
        if (strcmp(mac, "00:00:00:00:00:00") != 0) {
            if (!es_segura(mac)) {
                printf("[!] BLOQUEANDO INTRUSO: %s\n", mac);
                char comando[512];
                sprintf(comando, "curl -s -u %s:%s -X POST -d \"mac=%s&action=deny\" http://%s/config/filter.cgi", 
                        USER,
