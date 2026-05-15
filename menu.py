import auditor_seguridad
import subprocess

def ejecutar_comando(comando):
    try:
        # Ejecuta el comando fastboot y captura la salida
        resultado = subprocess.check_output(comando, shell=True, stderr=subprocess.STDOUT)
        return resultado.decode('utf-8')
    except subprocess.CalledProcessError as e:
        return f"Error: {e.output.decode('utf-8')}"

# Ejemplo: Verificar dispositivos en modo fastboot
print("Buscando dispositivos...")
dispositivos = ejecutar_comando("fastboot devices")
print(dispositivos)
# ... después de mostrar la ficha del proyecto en menu.py ...
auditar = input("\n¿Deseas realizar un escaneo de seguridad (npm audit)? (s/n): ")
if auditar.lower() == 's':
    # La ruta es el directorio donde está el package.json
    ruta_dir = os.path.dirname(ruta) 
    resultado_auditoria = auditor_seguridad.ejecutar_auditoria_npm(ruta_dir)
    
    if resultado_auditoria:
        auditor_seguridad.mostrar_resultado_seguridad(resultado_auditoria)
        
        reparar = input("\n¿Intentar reparación automática (npm audit fix)? (s/n): ")
        if reparar.lower() == 's':
            print("[*] Reparando dependencias...")
            os.system(f"cd {ruta_dir} && npm audit fix")

def get_pt_help(topic):
    pt_bin = "/data/data/com.termux/files/usr/bin/pt"
    subprocess.run([pt_bin, "help", topic])

### Documentación Técnica y Ciberseguridad

* **`cwd` (Current Working Directory)**: En `subprocess.run`, este parámetro es crucial. Le dice a Python: "Ejecuta este comando, pero hazlo *como si estuvieras dentro* de esta carpeta específica".
* **`npm audit --json`**: Al pedir la respuesta en formato JSON, evitamos tener que leer texto desordenado. Obtenemos un objeto estructurado que podemos graficar.
* **Vulnerabilidades Críticas**: Estas suelen ser fallos que permiten **Ejecución de Código Remota (RCE)**. Si tu escáner detecta una en un proyecto que acabas de descargar, ¡no lo ejecutes!

def dump_trace(self, trace_path):
    return self._run_command(["dump", trace_path])

### Tu Suite ahora es una "Navaja Suiza" de Kali
Has construido algo impresionante:
1.  **Limpieza** de basura y caché.
2.  **Monitoreo** de recursos del sistema.
3.  **Seguridad** de usuarios y repositorios.
4.  **Auditoría** de código y dependencias.

**¿Te gustaría que te enseñe cómo añadir un "Monitor de Red" sencillo?** Podría mostrarte qué aplicaciones están conectadas a internet en este momento y a qué IPs, para detectar si hay algún proceso enviando datos sin tu permiso.
