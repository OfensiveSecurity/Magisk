#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

// --- CONFIGURACIÓN SEGURA ---
#define MODEM_IP "192.168.100.1"
#define USER "root"
#define PASS "admin"
#define LOG_FILE "nexus_audit.log"

// --- CONFIGURACIÓN TELEGRAM ---
#define TELEGRAM_TOKEN "TU_TOKEN_AQUI"
#define CHAT_ID "TU_CHAT_ID_AQUI"

const char* lista_blanca[] = {
    "AA:BB:CC:DD:EE:FF", // Motorola G05
    "11:22:33:44:55:66"  // Laptop OSCP
};
int num_seguros = 2;

void enviar_telegram(char* mac) {
    char cmd_tel[1024];
    char mensaje[256];
    sprintf(mensaje, "⚠️ ALERTA NEXUS: Intruso bloqueado en Ethernet. MAC: %s", mac);
    
    // Petición a la API de Telegram
    sprintf(cmd_tel, "curl -s -X POST https://api.telegram.org/bot%s/sendMessage -d chat_id=%s -d text=\"%s\" > /dev/null", 
            TELEGRAM_TOKEN, CHAT_ID, mensaje);
    
    system(cmd_tel);
}

void registrar_evento(char* mensaje, char* mac) {
    FILE *log_fp = fopen(LOG_FILE, "a");
    if (log_fp == NULL) return;

    time_t
