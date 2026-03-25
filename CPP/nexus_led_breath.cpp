#include <iostream>
#include <fstream>
#include <unistd.h>

void led_breath_cycle() {
    std::ofstream led("/sys/class/leds/blue/brightness");
    if (!led.is_open()) return;

    // Ciclo de respiración infinito (Modo Centinela)
    while(true) {
        for(int i=0; i<255; i+=5) { led << i << std::flush; usleep(20000); }
        for(int i=255; i>0; i-=5) { led << i << std::flush; usleep(20000); }
        sleep(2); // Pausa entre "respiros" para máximo ahorro
    }
}

int main() {
    std::cout << "[🔵] MODO RESPIRACIÓN ACTIVADO. SISTEMA NOMINAL." << std::endl;
    led_breath_cycle();
    return 0;
}
