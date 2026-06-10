#include <iostream>
#include <unistd.h>

void activate_low_power() {
    // 1. Apagar servicios pesados (Dashboard Web y Python)
    system("pkill -f http.server");
    
    // 2. Bajar frecuencia de la CPU (Requiere Root/Magisk)
    system("echo 'powersave' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor");
    
    // 3. Mantener vivo el Radar y las Alertas
    std::cout << "[⚡] Modo Ahorro Táctico: Dashboard OFF | Radar ON" << std::endl;
}

int main() {
    activate_low_power();
    return 0;
}
