#include <iostream>
#include <string>
#include <unistd.h>
#include <cmath>

// Función para obtener la potencia de la señal (RSSI)
int get_rssi(std::string mac) {
    // Escaneo rápido de la interfaz wlan0
    std::string cmd = "iw dev wlan0 scan | grep -A 10 " + mac + " | grep 'signal' | awk '{print $2}'";
    // Simulación de captura de valor (ej. -40 es fuerte, -90 es débil)
    return -60; 
}

void trigger_beep(int intensity) {
    // A mayor intensidad (valor más cercano a 0), menor el delay entre beeps
    int delay = std::abs(intensity) * 5000; 
    system("termux-beep -f 1000 -d 100"); 
    usleep(delay);
}

int main() {
    std::string target_mac = "XX:XX:XX:XX:XX:XX"; // Tu Laptop/Antena
    std::cout << "[📡] MODO RASTREO ACÚSTICO ACTIVO..." << std::endl;

    while(true) {
        int rssi = get_rssi(target_mac);
        if (rssi != 0) {
            trigger_beep(rssi);
        }
        usleep(500000); // Muestreo cada medio segundo
    }
    return 0;
}
