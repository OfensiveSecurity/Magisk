#include <iostream>
#include <unistd.h>

void night_sentry(int threshold) {
    std::cout << "[💤] MODO SUEÑO SEGURO... UMBRAL: " << threshold << " dBm" << std::endl;
    
    while(true) {
        int current_signal = -95; // Simulación de lectura del sensor
        
        if (current_signal > threshold) {
            // DISPARAR ALERTA CRÍTICA
            system("termux-vibrate -d 5000"); // Vibración continua
            system("termux-tts-speak 'ALERTA: Contacto detectado. Proximidad alta.'");
            break; 
        }
        sleep(10); // Escaneo cada 10 segundos para ahorrar batería
    }
}

int main() {
    night_sentry(-50); // Solo alerta si la señal es muy fuerte
    return 0;
}
