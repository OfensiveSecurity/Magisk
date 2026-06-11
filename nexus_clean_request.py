import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

def check_sat_access():
    url = "https://www.sat.gob.mx/tramites"
    
    # User-Agent de Chrome en Windows para evitar bloqueos por 'dispositivo móvil'
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36',
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,webp,*/*;q=0.8',
        'Accept-Language': 'es-MX,es;q=0.8,en-US;q=0.5,en;q=0.3',
        'Connection': 'keep-alive',
        'Upgrade-Insecure-Requests': '1'
    }

    session = requests.Session()
    # Configurar reintentos automáticos
    retries = Retry(total=3, backoff_factor=1, status_forcelist=[500, 502, 503, 504])
    session.mount('https://', HTTPAdapter(max_retries=retries))

    print(f"[*] NEXUS PROXY: Intentando acceso limpio a {url}...")
    
    try:
        # Petición sin proxies del sistema
        response = session.get(url, headers=headers, timeout=15, proxies={'http': None, 'https': None})
        
        print(f"[i] Código de Respuesta: {response.status_code}")
        
        if response.status_code == 200:
            print("[✓] ACCESO EXITOSO. El bloqueo era por tu Navegador o IP.")
        elif response.status_code == 403:
            print("[!] ERROR 403 PERSISTE. El servidor del SAT está bloqueando activamente tu IP actual.")
        else:
            print(f"[?] Respuesta inesperada: {response.status_code}")
            
    except Exception as e:
        print(f"[!] Error de conexión: {e}")

if __name__ == "__main__":
    check_sat_access()
