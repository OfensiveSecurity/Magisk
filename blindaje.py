import os
import tarfile
import hashlib
from datetime import datetime

# Carpeta donde se guardarán los respaldos
RUTA_PROYECTO = "/root/proyectos/limpieza"
CARPETA_BACKUPS = os.path.join(RUTA_PROYECTO, "backups_seguridad")

def crear_respaldo_total():
    """Comprime todo el proyecto en un archivo .tar.gz con fecha."""
    if not os.path.exists(CARPETA_BACKUPS):
        os.makedirs(CARPETA_BACKUPS)

    fecha = datetime.now().strftime("%Y%m%d_%H%M%S")
    nombre_archivo = f"backup_suite_{fecha}.tar.gz"
    ruta_destino = os.path.join(CARPETA_BACKUPS, nombre_archivo)

    print(f"\n[*] Iniciando blindaje de datos en: {nombre_archivo}...")
    
    try:
        with tarfile.open(ruta_destino, "w:gz") as tar:
            # Añadimos todos los archivos .py y la base de datos .db
            for raiz, dirs, archivos in os.walk(RUTA_PROYECTO):
                # No respaldamos la carpeta de backups ni el venv para ahorrar espacio
                if "backups_seguridad" in raiz or "venv" in raiz:
                    continue
                for f in archivos:
                    if f.endswith(('.py', '.db', '.txt', '.sh')):
                        ruta_file = os.path.join(raiz, f)
                        # Guardamos con ruta relativa para facilitar la restauración
                        rel_path = os.path.relpath(ruta_file, RUTA_PROYECTO)
                        tar.add(ruta_file, arcname=rel_path)
        
        print(f"[✅] Respaldo de seguridad completado con éxito.")
        return True
    except Exception as e:
        print(f"[❌] Error durante el respaldo: {e}")
        return False

def verificar_integridad_archivo(ruta):
    """Calcula el hash SHA-256 de un archivo para detectar cambios."""
    sha256_hash = hashlib.sha256()
    try:
        with open(ruta, "rb") as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()
    except FileNotFoundError:
        return None

def auditoria_de_archivos():
    """Verifica si los archivos principales del sistema están presentes."""
    archivos_criticos = ['menu.py', 'seguridad_db.py', 'usuarios.db']
    print("\n[*] Verificando integridad del sistema...")
    for f in archivos_criticos:
        ruta = os.path.join(RUTA_PROYECTO, f)
        if os.path.exists(ruta):
            print(f" [OK] {f} - Presente")
        else:
            print(f" [⚠️] {f} - ¡FALTA O ESTÁ CORRUPTO!")