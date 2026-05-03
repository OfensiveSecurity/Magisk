import limpiador_dev

# ... dentro del menú ...
elif opcion.upper() == "D": # D de Desarrollo
    ruta_dev = input("Introduce la ruta de tus proyectos (Ej: /root/proyectos): ")
    hallazgos = limpiador_dev.escanear_proyectos_pesados(ruta_dev)
    
    if hallazgos:
        print("\n--- CARPETAS DE DESARROLLO DETECTADAS ---")
        for i, (r, t) in enumerate(hallazgos, 1):
            print(f"{i}. {r} ({t:.2f} MB)")
        
        confirmar = input("\n¿Deseas borrar TODAS estas carpetas? (s/n): ")
        if confirmar.lower() == 's':
            liberado = limpiador_dev.ejecutar_limpieza_dev(hallazgos)
            print(f"\n[✅] ¡Éxito! Recuperaste {liberado:.2f} MB de espacio de desarrollo.")
    else:
        print("[+] No se encontraron carpetas pesadas de desarrollo.")

---

### Documentación de los Archivos que Viste:

* **`package.json`**: Es el manifiesto del proyecto. Dice qué librerías necesita. Si borras `node_modules`, siempre puedes recuperarlo con `npm install`.
* **`snowpack.config.json`**: Configuración de un empaquetador de archivos rápido (alternativa a Webpack).
* **`shrinkwrap.yaml` / `package-lock.json`**: Aseguran que todos los programadores del equipo usen exactamente la misma versión de las librerías.

**¿Te gustaría que añadamos un "Lector de package.json" a tu suite?** Podría mostrarte automáticamente qué nombre tiene el proyecto y qué versión es sin que tengas que abrir el archivo manualmente.
