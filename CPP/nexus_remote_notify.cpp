#include <iostream>
#include <string>
#include <unistd.h>

// Credenciales de Emergencia (Bot de Telegram)
const std::string BOT_TOKEN = "TU_TOKEN_NEXUS";
const std::string CHAT_ID = "TU_ID_DE_OPERADOR";

void sendTelegramAlert(std::string message) {
    std::string cmd = "curl -s -X POST https://api.telegram.org/bot" + BOT_TOKEN + 
                      "/sendMessage -d chat_id=" + CHAT_ID + " -d text='" + message + "'";
    system(cmd.c_str());
}

void triggerTacticalVibration() {
    // Código Morse para "SOS" en el Moto E13
    system("termux-vibrate -d 200 -f"); // S
    system("termux-vibrate -d 500 -f"); // O
    system("termux-vibrate -d 200 -f"); // S
}

int main() {
    std::cout << "[*] SISTEMA DE NOTIFICACIÓN REMOTA ACTIVO..." << std::endl;

    while(true) {
        // Si el radar detecta el equipo robado
        if (system("iw dev wlan0 scan | grep -i XX:XX:XX:XX:XX:XX") == 0) {
            std::string alert = "[⚠️] NEXUS ALERT: Laptop/Antena detectada en Naucalpan. Iniciando rastreo GPS.";
            sendTelegramAlert(alert);
            triggerTacticalVibration();
            break; 
        }
        sleep(5); 
    }
    return 0;
}
