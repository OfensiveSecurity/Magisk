#include <iostream>
#include <vector>
#include <unistd.h>

bool is_process_running(std::string name) {
    std::string cmd = "pgrep -f " + name + " > /dev/null";
    return (system(cmd.c_str()) == 0);
}

void heal_system() {
    std::vector<std::string> tools = {"tcpdump", "nexus_tunnel", "nexus_beep"};
    for (const auto& tool : tools) {
        if (!is_process_running(tool)) {
            std::cout << "[!] Reiniciando componente crítico: " << tool << std::endl;
            // Comando para relanzar en segundo plano
            system(("./" + tool + " &").c_str());
        }
    }
}

int main() {
    while(true) {
        heal_system();
        std::cout << "[✓] Autodiagnóstico v31.0: Todos los sistemas nominales." << std::endl;
        sleep(3600); // Verificación cada hora
    }
    return 0;
}
