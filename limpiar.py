import os

def limpiar_instaladores(ruta_descargas):
    # Extensiones de archivos que queremos limpiar
    extensiones_a_borrar = ['.apk', '.deb', '.idsig', '.dat']
    
    print(f"[*] Iniciando limpieza en: {ruta_descargas}")
    
    try:
        # Listar todos los archivos en la ruta
        archivos = os.listdir(ruta_descargas)
        contador = 0

        for archivo in archivos:
            # Obtener la extensión del archivo
            nombre, ext = os.path.splitext(archivo)
            
            if ext.lower() in extensiones_a_borrar:
                ruta_completa = os.path.join(ruta_descargas, archivo)
                
                # ¡CUIDADO! os.remove borra permanentemente
                print(f"[!] Borrando: {archivo}")
                os.remove(ruta_completa)
                contador += 1
        
        print(f"\n[+] Limpieza completada. Se eliminaron {contador} archivos.")
        
    except FileNotFoundError:
        print("[-] Error: No se encontró la ruta especificada.")
    except PermissionError:
        print("[-] Error: No tienes permisos para borrar archivos en esa carpeta.")

# --- Ejecución ---
# Ajustamos la ruta a tu carpeta de descargas de Android
ruta_android = "/sdcard/Download"

# Confirmación de seguridad
confirmar = input(f"¿Estás seguro de borrar instaladores en {ruta_android}? (s/n): ")
if confirmar.lower() == 's':
    limpiar_instaladores(ruta_android)
else:
    print("[x] Operación cancelada.")
