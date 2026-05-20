import auditor_seguridad
import subprocess
import re

def analizar_linpeas(log_input):
    # Regex para extraer procesos y sus contextos
    pattern = r"Process (\d+) \((.*?)\) - (.*?)\nSELinux context: (.*?)$"
    
    procesos_relevantes = []
    
    # Limpiamos el ruido de los "null bytes" y procesamos línea por línea
    lines = log_input.strip().split('\n')
    content = "\n".join([line for line in lines if "warning: command substitution" not in line])
    
    matches = re.finditer(pattern, content, re.MULTILINE)
    
    print(f"{'PID':<8} | {'Usuario':<8} | {'Contexto SELinux':<45} | {'Comando'}")
    print("-" * 100)
    
    for match in matches:
        pid, user, cmd, selinux = match.groups()
        # Resaltamos si algo NO es untrusted_app (poco probable en PRoot)
        alerta = " [!] PRIVILEGIADO" if "untrusted_app" not in selinux else ""
        
        print(f"{pid:<8} | {user:<8} | {selinux[:43]:<45} | {cmd}{alerta}")

# Tu log de LinPEAS
log_data = """
linpeas.sh: line 4425: warning: command substitution: ignored null byte in input
Process 3139 (root) - proot --link2symlink -0 -r kali-arm64
SELinux context: u:r:untrusted_app_27:s0:c254,c256,c512,c768
Process 13752 (root) - fastboot flash
SELinux context: u:r:untrusted_app_27:s0:c254,c256,c512,c768
"""
analizar_linpeas(log_data)

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

def main():
    # Reemplaza esto con la lógica de tu argumento (ej. sys.argv[1])
    payload_file = 'autopsy' 

    try:
        # Intenta abrir el archivo de forma segura
        with open(payload_file, "rb") as f:
            payload_data = f.read()
            print(f"[+] Archivo '{payload_file}' cargado con éxito. Tamaño: {len(payload_data)} bytes.")
            # Aquí continúa el resto de tu código para enviar el payload
            
    except FileNotFoundError:
        print(f"[-] Error: El archivo '{payload_file}' no existe en el directorio actual.")
        print(f"[i] Directorio de ejecución actual: {os.getcwd()}")
        sys.exit(1)
        
    except PermissionError:
        print(f"[-] Error: No tienes permisos para leer el archivo '{payload_file}'.")
        sys.exit(1)

if __name__ == "__main__":
    main()
