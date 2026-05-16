#!/usr/bin/env python3
import sys
import subprocess
import shutil

def main():
    # 1. Definir el comando base
    comando_base = "dnsrecon"

    # 2. Verificar si dnsrecon está instalado en el sistema
    if not shutil.which(comando_base):
        print(f"[-] Error: '{comando_base}' no está instalado o no se encuentra en el PATH.")
        sys.exit(1)

    # 3. Capturar de forma dinámica todos los argumentos pasados al script
    # sys.argv[1:] toma absolutamente todo lo que escribas después del script
    argumentos_usuario = sys.argv[1:]

    # Construir la lista completa para la ejecución
    comando_completo = [comando_base] + argumentos_usuario

    try:
        print(f"[+] Ejecutando de forma segura: {' '.join(comando_completo)}")
        
        # 4. Ejecutar dnsrecon manteniendo la interactividad de la terminal
        # Esto permite que los colores, tablas y outputs se vean en tiempo real
        resultado = subprocess.run(comando_completo, check=True)
        
    except FileNotFoundError:
        # Estructura de control solicitada en caso de fallo catastrófico del binario
        print(f"[-] Error: No se pudo ejecutar el comando base '{comando_base}'.")
        sys.exit(1)
        
    except KeyboardInterrupt:
        # Captura si el usuario presiona Ctrl+C durante el escaneo
        print("\n[!] Escaneo cancelado por el usuario.")
        sys.exit(0)
        
    except subprocess.CalledProcessError as e:
        # Captura si dnsrecon regresa un código de error de salida
        print(f"\n[-] dnsrecon terminó con un código de error: {e.returncode}")
        sys.exit(e.returncode)

if __name__ == "__main__":
    main()
