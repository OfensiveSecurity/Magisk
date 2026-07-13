import psutil
import socket

def obtener_nombre_proceso(pid):
    """Obtiene el nombre del proceso a partir de su ID (PID)."""
    try:
        return psutil.Process(pid).name()
    except (psutil.NoSuchProcess, psutil.AccessDenied):
        return "Desconocido"

def listar_conexiones_activas():
    """Escanea y muestra las conexiones de red establecidas."""
    print("\n" + "═" * 60)
    print("   🌐 MONITOR DE CONEXIONES DE RED (ESTABLECIDAS)")
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