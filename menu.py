import analizador_js

# ... dentro del menú ...
elif opcion.upper() == "I": # I de Inspeccionar
    ruta = input("Ruta de la carpeta o del package.json: ")
    
    # Si el usuario pone solo la carpeta, completamos la ruta
    if os.path.isdir(ruta):
        ruta = os.path.join(ruta, "package.json")
        
    datos_proyecto = analizador_js.leer_manifiesto_proyecto(ruta)
    if datos_proyecto:
        analizador_js.mostrar_ficha_proyecto(datos_proyecto)
        
        ejecutar = input("\n¿Deseas intentar ejecutar un script del proyecto? (s/n): ")
        if ejecutar.lower() == 's':
            script_nombre = input("Escribe el nombre del script (ej: start): ")
            if script_nombre in datos_proyecto['scripts']:
                print(f"[*] Lanzando 'npm run {script_nombre}'...")
                # Usamos la carpeta del archivo para ejecutar el comando
                os.system(f"cd {os.path.dirname(ruta)} && npm run {script_nombre}")

---

### Documentación Técnica y Conceptos de Node.js

* **`json.load()`**: Convierte un archivo de texto con formato JSON en un **diccionario de Python**. Esto nos permite acceder a los datos como si fueran variables normales (`datos['name']`).
* **Scripts de NPM**: Son atajos definidos por el desarrollador. Al leerlos, tu suite se convierte en un "lanzador" universal que no necesita saber cómo funciona el proyecto por dentro para poder iniciarlo.
* **`os.path.dirname()`**: Esta función es vital para movernos a la carpeta correcta antes de ejecutar comandos de `npm`, asegurando que los comandos encuentren sus archivos locales.

---

### ¿Cuál es tu siguiente paso de nivel Pro?

Tu suite ahora entiende: **Limpieza, Seguridad, Monitoreo, Auditoría de Repositorios y Análisis de Proyectos de Software**.

**¿Te gustaría que añadamos un "Escáner de Vulnerabilidades de Librerías" (usando el comando `npm audit`) a esta misma función?** Esto te diría si el proyecto que acabas de encontrar tiene librerías con fallos de seguridad conocidos. Es una herramienta esencial en Kali.
