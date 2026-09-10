#!/usr/bin/env python3
"""
Capturador avanzado de tramas 802.11 con CLI, filtrado por BSSID,
filtro de tipo de trama, channel hopping y live-dump a PCAP.
"""

import os
import sys
import time
import threading
import argparse
from scapy.all import sniff, PcapWriter, Dot11

# Control global para la detención limpia de hilos
ejecutando = True

# Mapeo de tipos de tramas 802.11 según la especificación Scapy
# type 0: Management (Administración)
# type 1: Control
# type 2: Data (Datos)
TIPOS_TRAMA = {
    "all": None,
    "mgmt": 0,
    "control": 1,
    "data": 2
}


def cambiar_canales(interfaz, tiempo_paso=2):
    """
    Hilo secundario que alterna progresivamente los canales del 1 al 13
    en la interfaz inalámbrica en modo monitor.
    """
    global ejecutando
    canales = list(range(1, 14))
    idx = 0
    
    while ejecutando:
        canal = canales[idx]
        # Cambia el canal de la tarjeta mediante comando del sistema
        os.system(f"iwconfig {interfaz} channel {canal} 2>/dev/null")
        idx = (idx + 1) % len(canales)
        time.sleep(tiempo_paso)


def obtener_argumentos():
    """
    Configura e interpreta la interfaz de línea de comandos (CLI).
    """
    parser = argparse.ArgumentParser(
        description="Herramienta CLI para captura y filtrado de tramas 802.11 a PCAP."
    )
    
    parser.add_argument(
        "-i", "--interface",
        required=True,
        help="Nombre de la interfaz en modo monitor (ej. wlan0mon)"
    )
    parser.add_argument(
        "-b", "--bssid",
        required=True,
        help="Dirección MAC/BSSID objetivo (ej. AA:BB:CC:DD:EE:FF)"
    )
    parser.add_argument(
        "-o", "--out",
        default="captura_filtrada.pcap",
        help="Nombre del archivo .pcap de salida (por defecto: captura_filtrada.pcap)"
    )
    parser.add_argument(
        "-t", "--type",
        choices=["all", "mgmt", "control", "data"],
        default="all",
        help="Tipo de trama a capturar: mgmt, control, data o all (por defecto: all)"
    )
    
    return parser.parse_args()


def iniciar_captura():
    """
    Función principal de captura y filtrado de paquetes.
    """
    global ejecutando
    args = obtener_argumentos()
    
    interfaz = args.interface
    bssid_objetivo = args.bssid.lower()
    archivo_salida = args.out
    filtro_tipo = TIPOS_TRAMA[args.type]

    print("=" * 65)
    print("      CAPTURADOR CLI DE TRAMAS 802.11 - FILTRADO AVANZADO")
    print("=" * 65)
    print(f"[*] Interfaz:         {interfaz}")
    print(f"[*] BSSID Objetivo:   {bssid_objetivo}")
    print(f"[*] Archivo salida:   {archivo_salida}")
    print(f"[*] Filtro de tipo:   {args.type.upper()}")
    print("[*] Salto de canales: Habilitado (Canales 1 - 13)")
    print("[*] Presiona Ctrl+C para detener la captura.\n")

    # Iniciar hilo para el cambio automático de canales
    hilo_canales = threading.Thread(target=cambiar_canales, args=(interfaz,))
    hilo_canales.daemon = True
    hilo_canales.start()

    contador = 0

    try:
        # PcapWriter guarda de forma directa en disco cada trama recibida
        with PcapWriter(archivo_salida, append=True, sync=True) as pcap_dumper:
            
            def procesar_paquete(paquete):
                nonlocal contador
                
                # Verificar que el paquete posea la capa Wi-Fi (Dot11)
                if paquete.haslayer(Dot11):
                    # Filtrado opcional por tipo de trama (mgmt=0, control=1, data=2)
                    if filtro_tipo is not None and paquete.type != filtro_tipo:
                        return

                    # Extraer direcciones MAC de la trama 802.11
                    addr1 = paquete.addr1.lower() if paquete.addr1 else ""
                    addr2 = paquete.addr2.lower() if paquete.addr2 else ""
                    addr3 = paquete.addr3.lower() if paquete.addr3 else ""

                    # Comprobar coincidencia con el BSSID objetivo
                    if bssid_objetivo in (addr1, addr2, addr3):
                        pcap_dumper.write(paquete)
                        contador += 1
                        print(
                            f"[+] [{contador}] Trama guardada | "
                            f"Tipo: {paquete.type} | Subtipo: {paquete.subtype}"
                        )

            # Escucha continua en la interfaz especificada
            sniff(iface=interfaz, prn=procesar_paquete, store=False)

    except KeyboardInterrupt:
        print("\n\n[*] Captura detenida manualmente por el usuario.")
    except PermissionError:
        print("\n[-] Error: Se requieren permisos de superusuario (root) para capturar en modo monitor.")
        sys.exit(1)
    except Exception as e:
        print(f"\n[-] Error inesperado: {e}")
        sys.exit(1)
    finally:
        ejecutando = False
        print(f"[*] Total de paquetes guardados en '{archivo_salida}': {contador}")
        print("[+] Proceso finalizado exitosamente.")


if __name__ == "__main__":
    iniciar_captura()
