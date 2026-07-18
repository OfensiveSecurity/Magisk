#include <iostream>
#include <string>

void send_alert(std::string message) {
    // Usamos 'curl' en Termux para enviar una petición al Bot de Telegram
    // Sustituye con tu TOKEN y ID de Chat real
    std::string bot_token = "TU_TOKEN_AQUÍ";
    std::string chat_id = "TU_ID_AQUÍ";
    
    std::string cmd = "curl -s -X POST https://api.telegram.org/bot" + bot_token + 
                      "/sendMessage -d chat_id=" + chat_id + " -d text='" + message + "'";
    
    system(cmd.c_str());
}

int main() {
    std::cout << "[*] SISTEMA DE NOTIFICACIONES NEXUS ACTIVO..." << std::endl;
    
    // Simulación: Si el Radar detecta la Laptop con señal > -50dBm
    std::string alert_msg = "⚠️ [NEXUS ALERT] Objeto detectado en Naucalpan.\n"
                            "Dispositivo: Laptop Robada\n"
                            "Señal: FUERTE (-45 dBm)\n"
                            "Acción: Inicia rastreo con Beep Progresivo.";
    
    send_alert(alert_msg);
    return 0;
}
