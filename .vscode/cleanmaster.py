import os

# Diccionario de configuraciones de limpieza
# Formato: {nombre_archivo: {"remove_imports": [lista], "replace": {old: new}}}
tareas = {
    "menu.py": {"replace": {"elif opcion.upper() == \"D\":": "if opcion.upper() == \"D\":"}},
    "spy_logger.py": {"replace": {"except:\n    pass": "except requests.RequestException as e:\n        print(f'Error: {e}')"}},
    "app/Nexus_pay.py": {"remove_imports": ["import mfterm_api"]},
    "Wipe.py": {"remove_imports": ["import time"]},
    "get_magisk.py": {"remove_imports": ["import os"]},
    "app/mfterm_bridge.py": {"remove_imports": ["import json"]},
    "nexus_web_dashboard.py": {"remove_imports": ["import os"]},
    "nexus_web_dashboard_v2.py": {"replace": {"from flask import Flask, render_template_string, redirect, url_for": "from flask import Flask, render_template_string"}},
    "notificador.py": {"remove_imports": ["import os"]}
}

def aplicar_limpieza():
    for archivo, acciones in tareas.items():
        if not os.path.exists(archivo):
            print(f"Archivo no encontrado: {archivo}")
            continue
            
        with open(archivo, 'r') as f:
            contenido = f.read()
            
        # Limpiar imports
        if "remove_imports" in acciones:
            for imp in acciones["remove_imports"]:
                contenido = contenido.replace(imp, "")
        
        # Reemplazos de sintaxis
        if "replace" in acciones:
            for old, new in acciones["replace"].items():
                contenido = contenido.replace(old, new)
        
        with open(archivo, 'w') as f:
            f.write(contenido)
        print(f"Limpieza aplicada a: {archivo}")

if __name__ == "__main__":
    aplicar_limpieza()
