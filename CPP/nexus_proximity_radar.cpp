#include <iostream>
#include <string>
#include <unistd.h>

// Configuración de Alerta de Proximidad
const std::string TARGET_MAC = "XX:XX:XX:XX:XX:XX"; // MAC de tu laptop/antena

int main() {
    std::cout << "[*] RADAR DE PERÍMETRO INICIADO EN NAUCALPAN..." << std::endl;

    while(true) {
        // Escaneo pasivo de dispositivos cercanos
        std::string cmd = "iw dev wlan0 scan | grep -i " + TARGET_MAC;
        
        if (system(cmd.c_str()) == 0) {
            std::cout << "[!!!] OBJETIVO DETECTADO EN RANGO [!!!]" << std::endl;
            // Activar alarma sonora y vibración máxima
            system("termux-volume music 15");
            system("termux-tts-speak 'Alerta. Dispositivo robado detectado cerca. Revisa el GPS.'");
            system("termux-vibrate -d 5000 -f");
            break; // Detener para que el operador tome control
        }
        sleep(10); // Escaneo cada 10 segundos para cuidar el Unisoc T606
    }
    return 0;
}
