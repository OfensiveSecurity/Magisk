#include <iostream>
#include <string>
#include <map>

void launchService(std::string serviceName) {
    std::cout << "[*] Lanzando entorno vulnerable: " << serviceName << std::endl;
    // Comandos para iniciar servicios específicos en contenedores chroot o proot
    if(serviceName == "dvwa") system("php -S localhost:8081 -t ~/labs/dvwa &");
    if(serviceName == "mysql") system("mysqld --user=root &");
}

int main() {
    std::cout << "--- NEXUS PENTEST LAB v1.0 ---" << std::endl;
    std::cout << "1. DVWA (Web Vuln)\n2. MySQL (SQLi)\n3. Custom Buffer Overflow\n";
    
    int choice;
    std::cin >> choice;
    
    switch(choice) {
        case 1: launchService("dvwa"); break;
        case 2: launchService("mysql"); break;
        default: std::cout << "Opción no válida." << std::endl;
    }
    return 0;
}
