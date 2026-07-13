import time
import can
class SchaefflerLUIDriver:
    def __init__(self, interface='slcan', channel='/dev/tty.usbmodem14101', bitrate=500000):
        """
        Inicializa la conexión con el bus CAN.
        En macOS, los adaptadores seriales/SLCAN suelen aparecer como /dev/tty.usb...
        """                                                                                                                                                                              self.interface = interface
        self.channel = channel
        self.bitrate = bitrate
        self.bus = None
    def connect(self):
        try:
            # Configuración típica para adaptadores SLCAN (comunes en Mac)
            self.bus = can.interface.Bus(
                interface=self.interface,
                channel=self.channel,
                bitrate=self.bitrate
            )
            print(f"[*] Conectado exitosamente al bus CAN en {self.channel}")
        except Exception as e:
            print(f"[-] Error al conectar al bus CAN: {e}")
    def disconnect(self):
        if self.bus:
            self.bus.shutdown()
            print("[*] Conexión CAN cerrada.")
    def send_command(self, arbitration_id, data_bytes):
        """                                                                                                                                                                              Envía un mensaje CAN al componente Schaeffler.
        """
        if not self.bus:
            print("[-] No hay conexión activa al bus.")
            return
        # Validación de datos (Máximo 8 bytes para CAN Clásico)
        if len(data_bytes) > 8:
            raise ValueError("El protocolo CAN estándar solo soporta hasta 8 bytes de datos.")
        msg = can.Message(
            arbitration_id=arbitration_id,
            data=data_bytes,
            is_extended_id=False # Cambiar a True si Schaeffler usa IDs de 29 bits
        )
        try:
            self.bus.send(msg)
            print(f"[->] Mensaje enviado - ID: {hex(arbitration_id)} Datos: {[hex(b) for b in data_bytes]}")
        except can.CanError:
            print("[-] El mensaje no pudo ser enviado.")
    def read_telemetry(self, timeout=1.0):
        """
        Escucha el bus para recibir datos del Schaeffler LUI.
        """
        if not self.bus:
            return None
        print("[*] Esperando respuesta del componente...")
        msg = self.bus.recv(timeout)

        if msg is not None:
            print(f"[<-] Mensaje recibido - ID: {hex(msg.arbitration_id)}")
            # Aquí procesas los bytes según el manual de Schaeffler
            return msg.arbitration_id, msg.data
        else:
            print("[-] Tiempo de espera agotado (Timeout).")
            return None
# --- Ejemplo de Uso ---
if __name__ == "__main__":
    # Nota: Modifica el 'channel' según el puerto que asigne tu Mac (ej. /dev/cu.usbserial-...)
    driver = SchaefflerLUIDriver(interface='slcan', channel='/dev/tty.usbserial-1410', bitrate=500000)

    driver.connect()

    # Supongamos que el ID de comando del RepSet es 0x201 y el comando de activación es [0x01, 0x00]
    # (Deberás revisar la hoja de datos/matriz CAN específica de Schaeffler para los IDs reales)
    id_schaeffler = 0x201
    comando_activacion = [0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]

    driver.send_command(id_schaeffler, comando_activacion)

    # Leer respuesta
    driver.read_telemetry()

    driver.disconnect()