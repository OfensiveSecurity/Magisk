#include <iostream>
#include <fstream>

void add_module_log(std::string module_name, std::string status) {
    // Usamos el comando 'cat' del sistema para añadir datos a un log central
    std::string cmd = "echo 'Modulo: " + module_name + " | Estado: " + status + "' >> ~/nexus_projects/loot/modules_audit.log";
    system(cmd.c_str());
    
    std::cout << "[+] Log de modulo actualizado via Nexus Core.\n";
}
