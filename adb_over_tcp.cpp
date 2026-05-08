#include <iostream>
#include <cstdlib>
#include <string>

int main() {
    std::cout << "\033[1;34m[*] NEXUS SENTINEL: Monitoreando conexión inalámbrica...\033[0m\n";
    
    // Comando para buscar la entrada de conexión en el buffer de logs
    std::string monitor_cmd = "logcat -b events | grep --line-buffered 'adbd_auth_adb_connected'";
    
    // Si detecta la conexión, lanza una alerta visual (y sonora si el sistema lo permite)
    if (system(monitor_cmd.c_str()) == 0) {
        std::cout << "\a\n\033[1;32m[!] CONEXIÓN ESTABLECIDA: Bugjaeger está vinculado.\033[0m\n";
        // Comando para hacer vibrar el Moto G05 (requiere root/shell)
        system("cmd vibration flash"); 
    }
    
    return 0;
}
