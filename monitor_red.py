import psutil
import socket
import cv2
import os
import shutil
import subprocess
import sys

# Buscar la ruta absoluta de sshd en el PATH del sistema
sshd_path = shutil.which("sshd")

if not sshd_path:
    print("Error: No se encontró el binario sshd en el sistema.", file=sys.stderr)
    sys.exit(1)

print(f"Binario encontrado en: {sshd_path}")

# Ejecutar usando la ruta absoluta detectada
try:
    # Agrega los argumentos necesarios para tu caso de uso (ej. -t para probar la configuración)
    subprocess.run([sshd_path, "-t"], check=True)
    print("Configuración de sshd verificada con éxito.")
except subprocess.CalledProcessError as e:
    print(f"Fallo en la ejecución: {e}")
    
from pynput import keyboard
def quick_recon(target_ip):
    print(f"[*] Iniciando enumeración para: {target_ip}")
    # Automatizando Nmap (Escaneo de servicios y scripts básicos)
    try:
        nmap_cmd = f"nmap -sC -sV -oN nmap_recon_{target_ip}.txt {target_ip}"
        subprocess.run(nmap_cmd, shell=True, check=True)
        print("[+] Escaneo de Nmap completado.")
    except Exception as e:
        print(f"[!] Error en Nmap: {e}")
# Este tipo de automatización es la que se enseña para ganar tiempo en el examen.
def ejecutar_motor_cpp(datos_periferico):
    # Llama al ejecutable compilado en C++
    proceso = subprocess.Popen(['./motor_analisis.exe', datos_periferico], 
                               stdout=subprocess.PIPE, 
                               stderr=subprocess.PIPE)
    stdout, stderr = proceso.communicate()
    return stdout
# Captura de Cámara
cap = cv2.VideoCapture(0)
def on_press(key):
    print(f'Tecla presionada: {key}')
# Escucha de Teclado en segundo plano
listener = keyboard.Listener(on_press=on_press)
listener.start()
def obtener_nombre_proceso(pid):
    """Obtiene el nombre del proceso a partir de su ID (PID)."""
    try:
        return psutil.Process(pid).name()
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        return "Desconocido"
def listar_conexiones_activas():
    """Escanea y muestra las conexiones de red establecidas."""
    print("\n" + "═" * 60)
    print("   F/ MONITOR DE CONEXIONES DE RED (ESTABLECIDAS)")
    print("═" * 60)
    print(f"{'PROCESO':<15} | {'LOCAL':<20} | {'REMOTO':<20}")
    print("-" * 60)

    # Obtenemos todas las conexiones TCP
    conexiones = psutil.net_connections(kind='tcp')
    encontradas = 0
    for conn in conexiones:
        # Solo nos interesan las conexiones que ya están 'ESTABLISHED' (conectadas)
        if conn.status == 'ESTABLISHED':
            # Dirección local
            laddr = f"{conn.laddr.ip}:{conn.laddr.port}"
            # Dirección remota (a donde va la información)
            raddr = f"{conn.raddr.ip}:{conn.raddr.port}"
            
            nombre_proc = obtener_nombre_proceso(conn.pid)
            
            print(f"{nombre_proc[:14]:<15} | {laddr:<20} | {raddr:<20}")
            encontradas += 1
    if encontradas == 0:
        print("      [+] No hay conexiones externas activas ahora.")
    print("═" * 60)
    return encontradas
# Prueba rápida
if __name__ == "__main__":
    listar_conexiones_activas()
