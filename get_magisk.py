import requests
import os

# Configuración
REPO = "akdmjeau-eng/Magisk"
TOKEN = "TU_GITHUB_TOKEN" # Genera uno en Settings -> Developer Settings
HEADERS = {"Authorization": f"token {TOKEN}"}

def download_latest_magisk():
    print(f"[*] Buscando última compilación de {REPO}...")
    
    # 1. Obtener el último "Run" exitoso
    url = f"https://api.github.com/repos/{REPO}/actions/runs?status=success&per_page=1"
    run_data = requests.get(url, headers=HEADERS).json()
    
    if not run_data['workflow_runs']:
        print("[!] No se encontraron compilaciones exitosas.")
        return

    run_id = run_data['workflow_runs'][0]['id']
    
    # 2. Obtener el artefacto (APK)
    art_url = f"https://api.github.com/repos/{REPO}/actions/runs/{run_id}/artifacts"
    art_data = requests.get(art_url, headers=HEADERS).json()
    
    download_url = art_data['artifacts'][0]['archive_download_url']
    
    # 3. Descargar
    print(f"[+] Descargando Magisk desde Run #{run_id}...")
    r = requests.get(download_url, headers=HEADERS)
    with open("Magisk_Build.zip", "wb") as f:
        f.write(r.content)
    
    print("[OK] Archivo guardado como Magisk_Build.zip en Termux.")

if __name__ == "__main__":
    download_latest_magisk()
