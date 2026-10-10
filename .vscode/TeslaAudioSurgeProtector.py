import time
import random

class TeslaAudioSurgeProtector:
    def __init__(self, threshold=0.85):
        """
        Inicializa el protector de picos acústicos inspirado en la 
        supresión de transitorios de alto voltaje de Tesla.
        """
        self.threshold = threshold
        self.is_clamped = False

    def process_audio_stream(self, amplitude_level, channel_id):
        """
        Monitorea en tiempo real el flujo de audio envolvente por canal (ej. canales espaciales).
        """
        print(f"[*] Canal [{channel_id}] -> Amplitud de campo: {amplitude_level:.2f}")
        
        # Detección de sobrecarga o "explosión" sónica
        if amplitude_level > self.threshold:
            print(f"[⚡] ¡ALERTA! Pico explosivo detectado en canal {channel_id} ({amplitude_level:.2f} > {self.threshold})")
            self.trigger_resonance_breaker(channel_id)
        else:
            print(f"[+] Canal [{channel_id}] operando en rango de resonancia estable.")

    def trigger_resonance_breaker(self, channel_id):
        """
        Actúa como el descargador de una torre: aisla temporalmente 
        el canal y distribuye el corte para proteger la matriz envolvente.
        """
        self.is_clamped = True
        print(f"[🛡️] Disyuntor Tesla activado: Atenuando y distribuyendo el corte en canal {channel_id}.")
        
        # Simulación de la disipación del pico de energía
        time.sleep(0.3)
        
        self.is_clamped = False
        print(f"[*] Canal {channel_id} normalizado y reenganchado al flujo envolvente.\n")

if __name__ == "__main__":
    # Instanciar el controlador con un límite de umbral de seguridad
    protector = TeslaAudioSurgeProtector(threshold=0.80)
    
    print("=" * 60)
    print("      TESLA AUDIO SURGE PROTECTOR - Matriz Envolvente")
    print("=" * 60 + "\n")
    
    # Simulación de una secuencia de audio con variaciones e impactos explosivos repentinos
    canales = ["Frontal-Izq", "Frontal-Der", "Surround-Izq", "Surround-Der", "Subwoofer"]
    
    for ciclo in range(3):
        print(f"--- Ciclo de Monitoreo Espectral {ciclo + 1} ---")
        for ch in canales:
            # Simulamos niveles de amplitud aleatorios, con picos ocasionales de "explosión"
            amplitud_actual = random.uniform(0.3, 0.95)
            protector.process_audio_stream(amplitud_actual, ch)
            time.sleep(0.2)
        print("-" * 50)
        time.sleep(0.5)