import subprocess
import os

def enviar_alerta(titulo, mensaje, urgencia="normal"):
    """
    Envía una notificación visual al escritorio de Kali.
    Urgencias disponibles: low, normal, critical
    """
    try:
        # El comando notify-send es estándar en entornos Linux
        iconos = {
            "low": "dialog-information",
            "normal": "dialog-warning",
            "critical": "software-update-urgent"
        }
        
        icono = iconos.get(urgencia, "dialog-information")
        
        # Ejecutamos el comando de sistema
        subprocess.run([
            "notify-send", 
            "-u", urgencia, 
            "-i", icono, 
            titulo, 
            mensaje
        ], check=True)
        
        return True
    except FileNotFoundError:
        # Si notify-send no está instalado (raro en Kali)
        print(f"[!] Alerta de Sistema: {titulo} - {mensaje}")
        return False
    except Exception as e:
        print(f"[-] Error al enviar notificación: {e}")
        return False

# Prueba rápida
if __name__ == "__main__":
    enviar_alerta("Suite de Seguridad", "⚠️ Sistema de monitoreo activado correctamente.", "normal")