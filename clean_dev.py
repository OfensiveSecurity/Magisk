import os
import shutil

def escanear_proyectos_pesados(ruta_base):
    """Busca carpetas node_modules y builds en proyectos de programación."""
    carpetas_basura = ['node_modules', 'dist', 'build', '.cache']
    encontrados = []
    
    print(f"\n[*] Analizando proyectos en: {ruta_base}...")
    
    for raiz, dirs, archivos in os.walk(ruta_base):
        # Si encontramos un package.json, es un proyecto de Node.js
        if 'package.json' in archivos:
            for d in dirs:
                if d in carpetas_basura:
                    ruta_full = os.path.join(raiz, d)
                    try:
                        # Calcular tamaño antes de proponer borrar
                        tamaño_bytes = 0
                        for r, _, f_list in os.walk(ruta_full):
                            for f in f_list:
                                fp = os.path.join(r, f)
                                if not os.path.islink(fp):
                                    tamaño_bytes += os.path.getsize(fp)
                        
                        encontrados.append((ruta_full, tamaño_bytes / (1024*1024)))
                    except Exception:
                        continue
        
        # Optimización: No entrar en node_modules para seguir buscando más node_modules
        if 'node_modules' in dirs:
            dirs.remove('node_modules')

    return encontrados

def ejecutar_limpieza_dev(lista):
    total_mb = 0
    for ruta, tamaño in lista:
        try:
            print(f"[-] Eliminando: {ruta} ({tamaño:.2f} MB)...")
            shutil.rmtree(ruta)
            total_mb += tamaño
        except Exception as e:
            print(f"[❌] Error al borrar {ruta}: {e}")
    return total_mb