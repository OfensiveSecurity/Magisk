import json
import os

def leer_manifiesto_proyecto(ruta_archivo):
    """Lee y extrae información clave de un archivo package.json."""
    if not os.path.exists(ruta_archivo):
        print(f"[!] No se encontró el archivo en: {ruta_archivo}")
        return None

    try:
        with open(ruta_archivo, 'r', encoding='utf-8') as f:
            datos = json.load(f)
            
        info = {
            "nombre": datos.get("name", "Desconocido"),
            "version": datos.get("version", "0.0.0"),
            "descripcion": datos.get("description", "Sin descripción"),
            "scripts": datos.get("scripts", {}),
            "dependencias": len(datos.get("dependencies", {})),
            "dev_dependencias": len(datos.get("devDependencies", {}))
        }
        return info
    except json.JSONDecodeError:
        print("[❌] Error: El archivo package.json tiene un formato inválido.")
    except Exception as e:
        print(f"[❌] Error inesperado: {e}")
    return None

def mostrar_ficha_proyecto(info):
    """Muestra una ficha visual del proyecto encontrado."""
    if not info:
        return

    print("\n" + "═" * 45)
    print(f" 📦 PROYECTO: {info['nombre'].upper()}")
    print("" + "═" * 45)
    print(f" 🏷️  Versión:    {info['version']}")
    print(f" 📝 Descripción: {info['descripcion'][:40]}...")
    print(f" 📚 Librerías:  {info['dependencias']} principales / {info['dev_dependencias']} dev")
    
    if info['scripts']:
        print("\n ⚡ SCRIPTS DISPONIBLES:")
        for nombre in info['scripts'].keys():
            print(f"   • npm run {nombre}")
    print("═" * 45)

# Prueba rápida si se ejecuta este archivo
if __name__ == "__main__":
    # Intentar leer en el directorio actual
    resultado = leer_manifiesto_proyecto("package.json")
    if resultado:
        mostrar_ficha_proyecto(resultado)