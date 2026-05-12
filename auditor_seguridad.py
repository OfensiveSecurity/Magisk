import subprocess
import json
import os

def ejecutar_auditoria_npm(ruta_proyecto):
    """Ejecuta 'npm audit' y devuelve el resumen de seguridad."""
    if not os.path.exists(os.path.join(ruta_proyecto, "package.json")):
        print("[!] No se puede auditar: No se encontró package.json")
        return None

    print(f"\n[*] Iniciando auditoría de seguridad en: {ruta_proyecto}")
    print("[*] Consultando base de datos de vulnerabilidades... (Requiere Internet)")

    try:
        # Ejecutamos con --json para procesar los datos fácilmente
        resultado = subprocess.run(
            ["npm", "audit", "--json"],
            cwd=ruta_proyecto,
            capture_output=True,
            text=True
        )
        
        # npm audit devuelve código de salida > 0 si encuentra vulnerabilidades
        # así que parseamos el stdout independientemente del código de salida
        datos = json.loads(resultado.stdout)
        
        # Extraemos el resumen de metadatos
        resumen = datos.get("metadata", {}).get("vulnerabilities", {})
        
        if not resumen:
            print("[✅] ¡Felicidades! No se detectaron vulnerabilidades conocidas.")
            return None
            
        return resumen

    except FileNotFoundError:
        print("[❌] Error: 'npm' no está instalado en este sistema Kali.")
    except json.JSONDecodeError:
        print("[❌] Error al procesar la respuesta de npm audit.")
    except Exception as e:
        print(f"[❌] Error inesperado: {e}")
    return None

def mostrar_resultado_seguridad(resumen):
    """Muestra un reporte visual de los riesgos detectados."""
    if not resumen: return

    print("\n" + "!" * 45)
    print("   ⚠️  REPORTE DE VULNERABILIDADES  ⚠️")
    print("!" * 45)
    
    colores = {
        "critical": "🔴 CRÍTICO",
        "high":     "🟠 ALTO",
        "moderate": "🟡 MODERADO",
        "low":      "🟢 BAJO"
    }

    total = sum(resumen.values())
    
    for nivel, texto in colores.items():
        cantidad = resumen.get(nivel, 0)
        if cantidad > 0:
            barra = "█" * (cantidad if cantidad < 20 else 20)
            print(f"{texto:<12} | {barra} ({cantidad})")

    print("-" * 45)
    print(f" TOTAL DE RIESGOS: {total}")
    print("!" * 45)
    print("[💡] Sugerencia: Ejecuta 'npm audit fix' para intentar repararlos.")