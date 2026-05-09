#include <sys/capability.h>
#include <iostream>

void check_kernel_compatibility() {
    std::cout << "[*] Verificando permisos de bajo nivel..." << std::endl;
    
    // Verificar si somos root real o efectivo
    if (getuid() == 0) {
        std::cout << "[+] Privilegios de Superusuario: OK" << std::endl;
    } else {
        std::cout << "[-] Error: Se requiere ejecución vía tsudo/Magisk" << std::endl;
    }

    // Verificar si el driver de red está en modo monitor
    // (Esto requiere que el script de arriba haya funcionado)
    system("iw dev | grep type"); 
}
// Actualización del nexus_scanner.cpp
#include <fstream>
// ... (resto del código anterior) ...

void write_to_log(std::string data) {
    std::ofstream logfile;
    // Ruta al directorio público de Apache en Termux
    logfile.open("/data/data/com.termux/files/usr/var/www/html/nexus_logs.txt", std::ios_base::app);
    logfile << data << std::endl;
    logfile.close();
}
