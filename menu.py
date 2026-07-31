import blindaje

# ... al final de tu lógica de menú ...
elif opcion.upper() == "S": # S de Salir
    print("\n[*] Cerrando Suite de Seguridad...")
    
    # Realizar auditoría rápida antes de salir
    blindaje.auditoria_de_archivos()
    
    # Preguntar si se desea respaldar (o hacerlo automático)
    respaldar = input("\n¿Deseas realizar un respaldo de seguridad antes de salir? (s/n): ")
    if respaldar.lower() == 's':
        blindaje.crear_respaldo_total()
        
    print("\n[👋] ¡Hasta pronto, Auditor!")
    break

---

### Documentación Técnica y Ciberseguridad

* **`tarfile` (gz)**: Usamos el formato Gzip para comprimir. Es el estándar en Linux porque mantiene los permisos de archivos (lectura/escritura) intactos, lo cual es crítico para tus scripts de `sudo`.
* **SHA-256**: Es un algoritmo de hashing criptográfico. Si alguien cambia una sola letra en tu código, el hash cambiará por completo. Esto es lo que usan los antivirus para saber si un archivo ha sido infectado.
* **`os.path.relpath`**: Esta función es un "truco" de programador. Evita que el archivo comprimido guarde rutas absolutas como `/root/proyectos/...`. Al restaurarlo, los archivos se extraerán exactamente donde tú quieras.



---

### ¡Tu Suite es ahora una Fortaleza! 🏰

Has completado un ciclo de desarrollo profesional en Kali Linux:
1.  **Limpieza Inteligente** (Mantenimiento).
2.  **Seguridad de Usuarios** (Control de acceso).
3.  **Monitoreo de Red y Hardware** (Defensa).
4.  **Auditoría de Desarrollo** (AppSec).
5.  **Blindaje y Recuperación** (Resiliencia).

**¿Te gustaría que te ayude a crear un "Instalador Final" que configure todo automáticamente en una nueva máquina Kali, incluyendo la creación de carpetas y la instalación de todas las librerías (`psutil`, `shutil`, etc.) con un solo comando?** Sería el cierre perfecto para tu proyecto.
