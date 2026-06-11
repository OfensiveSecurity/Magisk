#include <iostream>
#include <string>

void morning_briefing() {
    std::string objective = "Enumeración de SMB y Escalada Lateral.";
    std::string target_tool = "Enum4linux y Smbclient.";
    
    std::cout << "[🌅] INICIANDO BRIEFING DEL 26 DE MARZO..." << std::endl;
    
    // Comando de voz (TTS) para Termux
    std::string speech = "termux-tts-speak 'Buen día, Operador. Objetivo de hoy: " + objective + 
                         " Herramientas principales: " + target_tool + ". El Radar Geiger no reportó intrusiones nocturnas.'";
    
    system(speech.c_str());
}

int main() {
    morning_briefing();
    return 0;
}
