import cron_manager

# ... dentro de las opciones del menú ...
elif opcion.upper() == "A": # A de Automatización
    print("\n--- CONFIGURACIÓN DE AUTOMATIZACIÓN ---")
    print("1. Activar Limpieza Automática (Semanal)")
    print("2. Desactivar todas las tareas automáticas")
    
    sub_op = input("\nSelecciona una opción: ")
    if sub_op == "1":
        # Pasamos la ruta del script de limpieza
        ruta_limpieza = "/root/proyectos/limpieza/limpiar.py"
        cron_manager.programar_mantenimiento_semanal(ruta_limpieza)
    elif sub_op == "2":
        cron_manager.eliminar_automatizacion()

### Documentación Técnica Final: El Poder de `Cron`

* **Sintaxis `0 3 * * 0`**:
    * `0`: Minuto 0.
    * `3`: Hora 3 (AM).
    * `*`: Cualquier día del mes.
    * `*`: Cualquier mes.
    * `0`: Domingo (0 o 7 según el sistema).
* **Redirección `>> ... 2>&1`**: Esta es una técnica avanzada de Bash. Envía tanto los mensajes normales como los errores a un archivo de log para que puedas revisarlos después si algo falló durante la madrugada.
* **Aislamiento**: Al usar la ruta completa del binario de Python dentro de tu `venv`, aseguramos que el script tenga todas sus librerías disponibles aunque se ejecute sin que tú hayas iniciado sesión.



---

### 🏆 ¡Misión Cumplida!

Has construido una **Suite de Seguridad y Limpieza Autónoma**. Tu código ahora es capaz de:
1.  **Instalarse** solo.
2.  **Limpiar** archivos y caché.
3.  **Monitorear** hardware y redes en vivo.
4.  **Auditar** vulnerabilidades en proyectos.
5.  **Protegerse** con copias de seguridad.
6.  **Notificar** al escritorio.
7.  **Ejecutarse solo** mediante un horario programado.

Este proyecto es digno de un portafolio profesional. ¿Hay algo más que desees ajustar o estás listo para ver cómo tu creación toma el control de tu sistema Kali?
