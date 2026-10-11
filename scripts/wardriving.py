import time
import threading

try:
    import can
except ImportError:
    can = None

class CANWatchdogSystem:
    def __init__(self, channel='can0', bustype='socketcan', timeout=3.0):
        self.channel = channel
        self.bustype = bustype
        self.timeout = timeout
        self.last_kick = time.time()
        self.running = True
        self.bus = None

    def kick(self):
        """Alimenta al watchdog actualizando la marca de tiempo."""
        self.last_kick = time.time()

    def aislar_sistema(self):
        """Rutina de emergencia fail-safe."""
        print("\n[⚡] ¡ALERTA CRÍTICA! Pérdida de comunicación o congelamiento en 'can0'.")
        print("[⚡] Ejecutando protocolo de aislamiento: cortando señales de potencia y protegiendo actuadores.")
        # Aquí puedes añadir código para apagar relés, cerrar sockets o registrar el evento

    def _watchdog_loop(self):
        """Hilo supervisor independiente que evalúa el tiempo transcurrido."""
        while self.running:
            elapsed = time.time() - self.last_kick
            if elapsed > self.timeout:
                self.aislar_sistema()
                self.running = False
                break
            time.sleep(0.2)

    def iniciar(self):
        if not can:
            print("[-] Error: La librería 'python-can' no está instalada.")
            return

        try:
            # Inicializar la interfaz SocketCAN (can0)
            self.bus = can.interface.Bus(channel=self.channel, bustype=self.bustype)
            print(f"[*] Sintonizado con éxito a la interfaz '{self.channel}'.")
            print(f"[*] Watchdog activo. Tiempo límite sin tramas: {self.timeout}s.\n")
        except Exception as e:
            print(f"[-] No se pudo abrir la interfaz {self.channel}: {e}")
            print("[*] Asegúrate de que la interfaz esté activa (ej: sudo ip link set can0 up)")
            return

        # Lanzar el hilo del watchdog en segundo plano
        wdt_thread = threading.Thread(target=self._watchdog_loop, daemon=True)
        wdt_thread.start()

        try:
            while self.running:
                # Esperar tramas en el bus con un pequeño timeout operativo
                message = self.bus.recv(timeout=0.5)
                
                if message is not None:
                    # Trama recibida correctamente -> Alimentamos al watchdog
                    self.kick()
                    print(f"[CAN] ID: 0x{message.arbitration_id:X} | DLC: {message.dlc} | Datos: {message.data.hex()}")
                else:
                    # Si no hay tramas en este ciclo de 0.5s, el bucle sigue 
                    # (el watchdog global decide si el silencio prolongado es un fallo)
                    pass

        except KeyboardInterrupt:
            print("\n[*] Interrupción manual detectada. Cerrando sistemas...")
        finally:
            self.running = False
            if self.bus:
                self.bus.shutdown()
            print("[*] Sistema cerrado de forma segura.")

if __name__ == "__main__":
    # Instanciar el sistema con un límite de tolerancia de 3 segundos sin tramas
    sistema_can_seguro = CANWatchdogSystem(channel='can0', timeout=3.0)
    sistema_can_seguro.iniciar()