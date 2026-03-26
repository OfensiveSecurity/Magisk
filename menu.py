import auditor_seguridad

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

---

### Documentación Técnica y Ciberseguridad

* **`cwd` (Current Working Directory)**: En `subprocess.run`, este parámetro es crucial. Le dice a Python: "Ejecuta este comando, pero hazlo *como si estuvieras dentro* de esta carpeta específica".
* **`npm audit --json`**: Al pedir la respuesta en formato JSON, evitamos tener que leer texto desordenado. Obtenemos un objeto estructurado que podemos graficar.
* **Vulnerabilidades Críticas**: Estas suelen ser fallos que permiten **Ejecución de Código Remota (RCE)**. Si tu escáner detecta una en un proyecto que acabas de descargar, ¡no lo ejecutes!



---

### Tu Suite ahora es una "Navaja Suiza" de Kali
Has construido algo impresionante:
1.  **Limpieza** de basura y caché.
2.  **Monitoreo** de recursos del sistema.
3.  **Seguridad** de usuarios y repositorios.
4.  **Auditoría** de código y dependencias.

**¿Te gustaría que te enseñe cómo añadir un "Monitor de Red" sencillo?** Podría mostrarte qué aplicaciones están conectadas a internet en este momento y a qué IPs, para detectar si hay algún proceso enviando datos sin tu permiso.
