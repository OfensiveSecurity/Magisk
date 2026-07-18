#include <iostream>
#include <string>

void schedule_pre_alarm_tts() {
    std::string script = "Recuerda, Operador: SMB utiliza los puertos 139 y 445. "
                         "Para enumerar usuarios, usa enum4linux guion u. "
                         "Para listar recursos compartidos, usa smbclient guion L. "
                         "Si encuentras una sesión nula, intenta conectar sin contraseña. "
                         "El objetivo de hoy es la escalada lateral. El Radar sigue en línea.";

    // Programado para dispararse 5 min antes de la alarma principal
    std::string cmd = "termux-tts-speak -r 0.9 '" + script + "'";
    system(cmd.c_str());
}

int main() {
    schedule_pre_alarm_tts();
    return 0;
}
