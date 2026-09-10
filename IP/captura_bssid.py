#!/usr/bin/env python3
"""
Script de captura de paquetes en modo monitor filtrado por BSSID.
Genera un archivo .pcap compatible con Wireshark.
"""

from scapy.all import sniff, wrpcap, Dot11

# --- CONFIGURACIÓN DE VARIABLES ---
INTERFAZ_MONITOR = "wlan0mon"       # Interfaz creada con airmon-ng
ARCHIVO_SALIDA = "captura_bssid.pcap" # Archivo de salida para Wireshark
LIMITE_PAQUETES = 50                 # Número de paquetes a capturar (0 = infinito)

# BSSID (Dirección MAC del Punto de Acceso) que deseas filtrar.
# Cambia esta dirección por la del AP que te interesa analizar.
BSSID_OBJETIVO = "aa:bb:cc:dd:ee:ff".lower()

# Lista en memoria para almacenar los paquetes filtrados
paquetes_filtrados = []


def filtrar_por_bssid(paquete):
    """
    Función de callback que inspecciona cada trama 802.11.
    Verifica si el BSSID objetivo coincide con alguna de las direcciones del paquete.
    """
    # Verificamos si el paquete contiene la capa Dot11 (Wi-Fi 802.11)
    if paquete.haslayer(Dot11):
        # Las tramas 802.11 tienen hasta 3 o 4 direcciones MAC (Receptor, Transmisor, BSSID)
        addr1 = paquete.addr1.lower() if paquete.addr1 else ""
        addr2 = paquete.addr2.lower() if paquete.addr2 else ""
        addr3 = paquete.addr3.lower() if paquete.addr3 else ""

        # Si el BSSID objetivo coincide con cualquier dirección del paquete
        if BSSID_OBJETIVO in (addr1, addr2, addr3):
            paquetes_filtrados.append(paquete)
            print(f"[+] Paquete coincidente capturado | BSSID: {BSSID_OBJETIVO} | Tipo: {paquete.type} Subtipo: {paquete.subtype}")


def iniciar_captura():
    """
    Inicia la captura en modo monitor y aplica el filtro por BSSID.
    """
    print(f"[*] Iniciando captura en '{INTERFAZ_MONITOR}'...")
    print(f"[*] Filtrando únicamente tramas asociadas al BSSID: {BSSID_OBJETIVO}")
    print("[*] Presiona Ctrl+C para detener la captura en cualquier momento.\n")

    try:
        # sniff escucha el tráfico y pasa cada paquete a la función prn
        sniff(
            iface=INTERFAZ_MONITOR,
            prn=filtrar_por_bssid,
            count=LIMITE_PAQUETES
        )

    except KeyboardInterrupt:
        print("\n[*] Captura detenida manualmente por el usuario.")
    except PermissionError:
        print("[-] Error: Se requieren permisos de superusuario (root).")
        return
    except Exception as e:
        print(f"[-] Ocurrió un error inesperado: {e}")
        return

    # Guardar los paquetes capturados si se encontró alguno
    if paquetes_filtrados:
        print(f"\n[*] Guardando {len(paquetes_filtrados)} paquetes en '{ARCHIVO_SALIDA}'...")
        wrpcap(ARCHIVO_SALIDA, paquetes_filtrados)
        print(f"[+] Archivo guardado exitosamente. Puedes abrirlo en Wireshark.")
    else:
        print("\n[-] No se capturaron paquetes que coincidieran con el BSSID especificado.")


if __name__ == "__main__":
    iniciar_captura()
