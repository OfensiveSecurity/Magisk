import requests
import os

# Configuración (Usa los mismos secretos de tu .yml)
TOKEN = "TU_TELEGRAM_TOKEN"
CHAT_ID = "TU_CHAT_ID"

def enviar_reporte():
    log_path = "/data/data/com.termux/files/home/registro_spam.log"
    
    if os.path.exists(log_path):
        with open(log_path, 'r') as f:
            lineas = f.readlines()
            total = len(lineas)
        
        mensaje = f"🏆 **Reporte Semanal de Victoria** 🏆\n\n🛡️ Tu escudo de C++ bloqueó **{total}** intentos de spam esta semana.\n\n✨ ¡Tu sistema Magisk sigue invicto!"
        
        url = f"https://api.googleapis.com/v1/messages:send?key={TOKEN}" # Estructura simplificada
        requests.post(f"https://api.telegram.org/bot{TOKEN}/sendMessage", 
                      data={"chat_id": CHAT_ID, "text": mensaje, "parse_mode": "Markdown"})
        
        # Opcional: Limpiar el log para la siguiente semana
        # open(log_path, 'w').close()

if __name__ == "__main__":
    enviar_reporte()
