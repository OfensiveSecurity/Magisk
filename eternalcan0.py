import time
import threading

def monitor_sistema_transmision(stop_event):
    """
    Función que se ejecuta en segundo plano como un hilo independiente.
    """
    print("[*] Hilo de supervisión activo en segundo plano...")
    tiempo_inicio = time.time()
    limite_tiempo = 3.0  # Segundos máximos de espera
    
    while not stop_event.is_set():
        tiempo_transcurrido = time.time() - tiempo_inicio
        
        # Verificar si se agotó el tiempo límite
        if tiempo_transcurrido > limite_tiempo:
            print(f"\n[!] Tiempo agotado ({tiempo_transcurrido:.2f}s). La transmisión no engranó.")
            aislar_sistema()
            stop_event.set()  # Detener el hilo automáticamente
            break
            
        # Pequeña pausa para no saturar la CPU
        time.sleep(0.5)
        
    print("[*] Hilo de supervisión cerrado correctamente.")

def aislar_sistema():
    print("[⚡] Aislamiento activado: Cortando señal de potencia para proteger contra cortocircuito.")

if __name__ == "__main__":
    # Evento de control para sincronizar la parada del hilo
    stop_signal = threading.Event()
    
    # Crear el hilo de supervisión
    hilo_monitor = threading.Thread(
        target=monitor_sistema_transmision, 
        args=(stop_signal,), 
        daemon=True
    )
    
    # Iniciar la ejecución en segundo plano
    hilo_monitor.start()
    
    print("[*] Programa principal ejecutando tareas simultáneas...")
    
    try:
        # Simulamos que el programa principal hace otras cosas durante 2 segundos
        for i in range(4):
            print(f"    [Principal] Sistema operativo ejecutando ciclo {i+1}/4")
            time.sleep(0.5)
            
        # Simulación: la transmisión enganchó con éxito a tiempo
        print("\n[+] Transmisión confirmada con éxito. Deteniendo el monitor de seguridad...")
        stop_signal.set()  # Ordena al hilo detenerse limpiamente
        
    except KeyboardInterrupt:
        print("\n[*] Interrupción detectada. Deteniendo sistema...")
        stop_signal.set()
        
    # Esperar a que el hilo de segundo plano finalice de forma ordenada
    hilo_monitor.join()
    print("[*] Programa principal finalizado de forma segura.")

def monitor_sistema_transmision():
    print("[*] Iniciando motor de supervisión de seguridad...")
    
    transmision_enganchada = False
    limite_tiempo = 3.0  # Segundos máximos de espera
    tiempo_inicio = time.time()
    
    while not transmision_enganchada:
        tiempo_transcurrido = time.time() - tiempo_inicio
        
        # Verificar si se agotó el tiempo sin éxito en la transmisión
        if tiempo_transcurrido > limite_tiempo:
            print(f"[!] Tiempo agotado ({tiempo_transcurrido:.2f}s). La transmisión no engranó.")
            aislar_sistema()
            break
            
        # Simulación de chequeo (en un entorno real, aquí leerías can0 o un sensor)
        time.sleep(0.5)
        # Cambiar a True para simular una transmisión exitosa
        # transmision_enganchada = True

def aislar_sistema():
    print("[⚡] Aislamiento activado: Cortando señal de potencia para proteger contra cortocircuito.")
    # Instrucciones de software para apagar actuadores o cerrar sockets

if __name__ == "__main__":
    monitor_sistema_transmision()