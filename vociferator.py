import socket
from cryptography.hazmat.primitives.asymmetric import x25519
import base64

# Configuración de los Ronnabytes
NEXUS_NODES = ["192.168.1.10", "192.168.1.15"] # IP del iPhone y Nokia
PORT = 8888

def broadcast_alert(message, private_key_b32):
    # Cifrado rápido para la alerta
    print(f"[📣] VOCIFERANDO: {message}")
    
    # Payload en Base32 para asegurar legibilidad en los drivers del sdm660
    payload = base64.b32encode(message.encode()).decode()
    
    for node in NEXUS_NODES:
        try:
            with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as s:
                s.sendto(f"NEXUS_ALERT:{payload}".encode(), (node, PORT))
        except Exception as e:
            pass # Silencio táctico si un nodo está offline

if __name__ == "__main__":
    broadcast_alert("INTRUSIÓN DETECTADA - SECTOR SÓTANO", "LLAVE_X25519_B32")
