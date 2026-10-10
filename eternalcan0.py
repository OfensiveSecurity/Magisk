import time

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