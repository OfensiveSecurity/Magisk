import ctypes
from ctypes import wintypes
import sys
import time

# ==========================================
# DEFINICIÓN DE ESTRUCTURAS DE LA WIN32 API
# ==========================================

# Cargamos las librerías nativas del sistema operativo Windows
kernel32 = ctypes.windll.kernel32

# Constantes de eventos de depuración
EXCEPTION_DEBUG_EVENT      = 1
CREATE_THREAD_DEBUG_EVENT  = 2
CREATE_PROCESS_DEBUG_EVENT = 3
EXIT_THREAD_DEBUG_EVENT    = 4
EXIT_PROCESS_DEBUG_EVENT   = 5
LOAD_DLL_DEBUG_EVENT       = 6
UNLOAD_DLL_DEBUG_EVENT     = 7
OUTPUT_DEBUG_STRING_EVENT  = 8
RIP_EVENT                  = 9

# Constantes de estado de continuación
DBG_CONTINUE              = 0x00010002
DBG_EXCEPTION_NOT_HANDLED = 0x80010001

# Definición de tipos de datos de ctypes para alineación en Windows
ULONG_PTR = ctypes.c_uint64 if ctypes.sizeof(ctypes.c_void_p) == 8 else ctypes.c_uint32

class EXCEPTION_RECORD(ctypes.Structure):
    pass

EXCEPTION_RECORD._fields_ = [
    ('ExceptionCode', wintypes.DWORD),
    ('ExceptionFlags', wintypes.DWORD),
    ('ExceptionRecord', ctypes.POINTER(EXCEPTION_RECORD)),
    ('ExceptionAddress', ctypes.c_void_p),
    ('NumberParameters', wintypes.DWORD),
    ('ExceptionInformation', ULONG_PTR * 15),
]

class EXCEPTION_DEBUG_INFO(ctypes.Structure):
    _fields_ = [
        ('ExceptionRecord', EXCEPTION_RECORD),
        ('dwFirstChance', wintypes.DWORD),
    ]

class DEBUG_EVENT_UNION(ctypes.Union):
    _fields_ = [
        ('Exception', EXCEPTION_DEBUG_INFO),
        ('padding', ctypes.c_byte * 160) # Padding de seguridad para unión en 64-bit
    ]

class DEBUG_EVENT(ctypes.Structure):
    _fields_ = [
        ('dwDebugEventCode', wintypes.DWORD),
        ('dwProcessId', wintypes.DWORD),
        ('dwThreadId', wintypes.DWORD),
        ('u', DEBUG_EVENT_UNION),
    ]

# ==========================================
# CLASE PRINCIPAL DEL DEPURADOR PERSISTENTE
# ==========================================

class DepuradorPersistenteWindows:
    def __init__(self, pid):
        """
        Inicializa el depurador asociándolo al PID del proceso objetivo.
        """
        self.pid = int(pid)
        self.depurando = False

    def acoplar_proceso(self):
        """
        Se conecta al proceso en ejecución usando la función DebugActiveProcess.
        """
        print(f"[*] Intentando acoplar al proceso objetivo con PID: {self.pid}...")
        if kernel32.DebugActiveProcess(self.pid):
            self.depurando = True
            print(f"[+] ¡Acoplado con éxito al proceso {self.pid}!")
            return True
        else:
            error = kernel32.GetLastError()
            print(f"[-] Error al acoplar al proceso. Código de error Windows: {error}")
            return False

    def bucle_depuracion(self):
        """
        Bucle persistente que escucha y procesa eventos del proceso depurado.
        """
        debug_event = DEBUG_EVENT()
        
        print("[*] Bucle de depuración activo. Escuchando eventos del sistema...")
        print("[*] Presiona Ctrl+C en esta terminal para detener la depuración.\n")

        try:
            while self.depurando:
                # Esperar infinitamente por un evento de depuración
                if kernel32.WaitForDebugEvent(ctypes.byref(debug_event), 1000):
                    
                    codigo_evento = debug_event.dwDebugEventCode
                    pid_evento = debug_event.dwProcessId
                    tid_evento = debug_event.dwThreadId

                    # Procesamiento de tipos de evento
                    if codigo_evento == EXCEPTION_DEBUG_EVENT:
                        excepcion = debug_event.u.Exception.ExceptionRecord
                        direccion = excepcion.ExceptionAddress
                        codigo = hex(excepcion.ExceptionCode)
                        print(f"[!] EXCEPCIÓN DETECTADA | PID: {pid_evento} | Hilo: {tid_evento}")
                        print(f"    -> Código Excepción: {codigo} | Dirección: {hex(direccion if direccion else 0)}")

                    elif codigo_evento == CREATE_THREAD_DEBUG_EVENT:
                        print(f"[+] Nuevo hilo creado en el proceso | TID: {tid_evento}")

                    elif codigo_evento == EXIT_THREAD_DEBUG_EVENT:
                        print(f"[-] Hilo finalizado | TID: {tid_evento}")

                    elif codigo_evento == EXIT_PROCESS_DEBUG_EVENT:
                        print(f"[!] El proceso objetivo (PID: {pid_evento}) ha finalizado.")
                        self.depurando = False

                    # Continuar la ejecución del proceso objetivo tras procesar el evento
                    kernel32.ContinueDebugEvent(pid_evento, tid_evento, DBG_CONTINUE)

        except KeyboardInterrupt:
            print("\n[*] Interrupción recibida. Desacoplando depurador...")
            self.desacoplar_proceso()

    def desacoplar_proceso(self):
        """
        Desconecta el depurador liberando el proceso objetivo de forma limpia.
        """
        if kernel32.DebugActiveProcessStop(self.pid):
            print(f"[+] Depurador desacoplado del PID {self.pid}. El proceso continuará ejecutándose normalmente.")
        else:
            print("[-] Error al desacoplar el depurador.")
        self.depurando = False

# ==========================================
# INICIO DE EJECUCIÓN
# ==========================================

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python depurador_windows.py <PID_del_Proceso>")
        print("Ejemplo: python depurador_windows.py 4124")
        sys.exit(1)

    pid_objetivo = sys.argv[1]
    depurador = DepuradorPersistenteWindows(pid_objetivo)

    if depurador.acoplar_proceso():
        depurador.bucle_depuracion()
