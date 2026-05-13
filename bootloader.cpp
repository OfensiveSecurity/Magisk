#include <iostream>
#include <cstdio>
#include <memory>
#include <stdexcept>
#include <string>

void check_bootloader_lock() {
    std::cout << "[*] NEXUS: Verificando estado del Bootloader...\n";
    
    // Ejecuta el comando de fastboot (solo si estás conectado a una shell con acceso)
    // O verifica propiedades del sistema si ya estás dentro de Android
    const char* cmd = "getprop ro.boot.flash.locked";
    
    // Si ro.boot.flash.locked es 0, está desbloqueado. Si es 1, está bloqueado.
    system(cmd); 
    
    std::cout << "[!] Nota: Si el valor es 1, el flasheo de Magisk fallará.\n";
}
