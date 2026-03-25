#include <iostream>
#include <map>

void display_cheat_sheet() {
    std::map<std::string, std::string> hints = {
        {"SUID", "find / -perm -u=s -type f 2>/dev/null"},
        {"Kernel", "uname -a (Buscar exploits en Exploit-DB)"},
        {"Capabilities", "getcap -r / 2>/dev/null"},
        {"Cron Jobs", "cat /etc/crontab (Buscar scripts editables)"},
        {"Sudo -l", "sudo -l (Ver qué comandos corren sin password)"}
    };

    std::cout << "--- TABLA DE ESCALADA RÁPIDA (OSCP) ---" << std::endl;
    for (auto const& [tech, cmd] : hints) {
        std::cout << "[" << tech << "]: " << cmd << std::endl;
    }
}

int main() {
    display_cheat_sheet();
    return 0;
}
