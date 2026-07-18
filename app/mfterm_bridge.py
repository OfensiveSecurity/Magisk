import subprocess
import json

def capture_mifare_payment():
    print("[💳] NEXUS-PAY: Esperando tarjeta en el lector...")
    # Ejecutamos mfterm en modo batch para leer el bloque de saldo
    result = subprocess.run(['mfterm', '-c', 'read 1'], capture_output=True, text=True)
    
    if "Success" in result.stdout:
        # Lógica para extraer el monto y validar la transacción
        monto_mxn = 1500.00 # Ejemplo de cobro
        return monto_mxn
    return 0
