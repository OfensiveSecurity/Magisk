from scapy.all import sniff, Dot11, Dot11Beacon, Dot11Elt
import os

# Almacén de líneas base de nodos legítimos conocidos (SSID -> BSSID)
known_baseline = {}

def inspect_rf_field(packet):
    """
    Analiza las emisiones de baliza (Beacons) para detectar anomalías 
    o duplicidades sospechosas en el espectro inalámbrico.
    """
    if packet.haslayer(Dot11Beacon):
        try:
            ssid_element = packet[Dot11Elt]
            ssid = ssid_element.info.decode('utf-8', errors='ignore')
            if not ssid:
                ssid = "<Red Oculta>"
        except Exception:
            ssid = "<Desconocido>"

        bssid = packet[Dot11].addr2

        # Extraer potencia de señal (RSSI) si está disponible en la cabecera Radiotap
        rssi = "N/A"
        if packet.haslayer('Radiotap'):
            try:
                rssi = packet['Radiotap'].dBm_AntSignal
            except AttributeError:
                pass

        # Detección de anomalías en el campo de radiofrecuencia
        if ssid not in ("<Red Oculta>", "<Desconocido>", ""):
            if ssid in known_baseline:
                if known_baseline[ssid] != bssid:
                    print(f"[!] ¡ALERTA DE ANOMALÍA EN EL CAMPO RF!")
                    print(f"    SSID: {ssid}")
                    print(f"    BSSID Legítimo registrado: {known_baseline[ssid]}")
                    print(f"    ¡Nueva fuente detectada!: {bssid} (RSSI: {rssi} dBm)\n")
            else:
                # Establecer línea base inicial
                known_baseline[ssid] = bssid
                print(f"[+] Nodo inicial catalogado: {ssid} -> {bssid} ({rssi} dBm)")

def start_rf_defense(interface):
    print("=" * 60)
    print("      TESLA ROGUE DETECTOR - Análisis Defensivo de RF")
    print("=" * 60)
    print(f"[*] Sintonizando interfaz '{interface}' en busca de anomalías...")
    print("[*] Monitoreando estabilidad del campo electromagnético local...\n")
    
    try:
        sniff(iface=interface, prn=inspect_rf_field, store=0)
    except PermissionError:
        print("[-] Error: Se requieren privilegios de superusuario (root) para acceder al adaptador.")
    except Exception as e:
        print(f"[-] Error en el analizador: {e}")

if __name__ == "__main__":
    target_interface = os.getenv("WIFI_IFACE", "wlan0mon")
    start_rf_defense(target_interface)