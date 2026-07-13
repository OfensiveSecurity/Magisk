import subprocess
import os

def programar_mantenimiento_semanal(ruta_script):
    """Programa una tarea en Crontab para cada domingo a las 3:00 AM."""
    # Comando que activa el venv y ejecuta el script de limpieza silenciosa
    comando_cron = f"0 3 * * 0 /root/proyectos/limpieza/venv/bin/python3 {ruta_script} --auto >> /root/proyectos/limpieza/logs/auto_mantenimiento.log 2>&1"
    
    try:
        # Obtenemos el crontab actual
        proceso = subprocess.run(['crontab', '-l'], capture_output=True, text=True)
        cron_actual = proceso.stdout if proceso.returncode == 0 else ""
        
        if comando_cron in cron_actual:
            print("[i] El mantenimiento automático ya está programado.")
            return True
            
        # Añadimos la nueva línea
        nuevo_cron = cron_actual + "\n" + comando_cron + "\n"
        
        # Guardamos el nuevo crontab
        process = subprocess.Popen(['crontab', '-'], stdin=subprocess.PIPE, text=True)
        process.communicate(input=nuevo_cron)
        
        print("[✅] Mantenimiento automático programado: Todos los domingos a las 03:00.")
        return True
    except Exception as e:
        print(f"[❌] Error al configurar crontab: {e}")
        return False

def eliminar_automatizacion():
    """Elimina las tareas programadas de la suite."""
    try:
        subprocess.run(['crontab', '-r'], check=True)
        print("[✅] Todas las tareas programadas han sido eliminadas.")
    except Exception:
        print("[!] No había tareas programadas para eliminar.")