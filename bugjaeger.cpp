#include <iostream>
#include <string>

class NexusCommander {
public:
    // Comando rápido para saltar de Android a Fastboot (Modo Flash)
    void rebootToBootloader() {
        std::cout << "[!] Reiniciando en modo Fastboot para desbloqueo...\n";
        system("adb reboot bootloader");
    }

    // Comando para forzar reinicio desde Bugjaeger (Shell)
    void fastbootReboot() {
        std::cout << "[*] Comando enviado: fastboot reboot\n";
        system("fastboot reboot");
    }

    // Detector de IP para conexión inalámbrica
    void showNetworkTarget() {
        std::cout << "[*] Escaneando red local para Nexus Bridge...\n";
        system("ip route | grep wlan0");
    }
};
