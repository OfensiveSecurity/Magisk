import ctypes
from ctypes import wintypes
import sys

# ==========================================
# IMPORTACIÓN DE LIBRERÍAS NATIVAS DE WINDOWS
# ==========================================
kernel32 = ctypes.windll.kernel32

# Constantes de depuración
EXCEPTION_DEBUG_EVENT      = 1
CREATE_THREAD_DEBUG_EVENT  = 2
EXIT_PROCESS_DEBUG_EVENT   = 5
DBG_CONTINUE              = 0x00010002

# Constante de acceso a hilos y contexto x86_64
THREAD_ALL_ACCESS          = 0x1F03FF
CONTEXT_FULL_AMD64         = 0x00100007

# ==========================================
# ESTRUCTURAS DE DATOS PARA INTEL X86_64
# ==========================================

# Estructura alineada de 128 bits requerida para registros MMX/XMM en Intel 64-bit
class M128A(ctypes.Structure):
    _fields_ = [
        ('Low', ctypes.c_uint64),
        ('High', ctypes.c_int64),
    ]

# Estructura CONTEXT para arquitecturas Intel x86_64
class CONTEXT64(ctypes.Structure):
    _pack_ = 16
    _fields_ = [
        ('P1Home', ctypes.c_uint64),
        ('P2Home', ctypes.c_uint64),
        ('P3Home', ctypes.c_uint64),
        ('P4Home', ctypes.c_uint64),
        ('P5Home', ctypes.c_uint64),
        ('P6Home', ctypes.c_uint64),
        ('ContextFlags', wintypes.DWORD),
        ('MxCsr', wintypes.DWORD),
        ('SegCs', wintypes.WORD),
        ('SegDs', wintypes.WORD),
        ('SegEs', wintypes.WORD),
        ('SegFs', wintypes.WORD),
        ('SegGs', wintypes.WORD),
        ('SegSs', wintypes.WORD),
        ('EFlags', wintypes.DWORD),
        ('Dr0', ctypes.c_uint64),
        ('Dr1', ctypes.c_uint64),
        ('Dr2', ctypes.c_uint64),
        ('Dr3', ctypes.c_uint64),
        ('Dr6', ctypes.c_uint64),
        ('Dr7', ctypes.c_uint64),
        ('Rax', ctypes.c_uint64),
        ('Rcx', ctypes.c_uint64),
        ('Rdx', ctypes.c_uint64),
        ('Rbx', ctypes.c_uint64),
        ('Rsp', ctypes.c_uint64),
        ('Rbp', ctypes.c_uint64),
        ('Rsi', ctypes.c_uint64),
        ('Rdi', ctypes.c_uint64),
        ('R8',  ctypes.c_uint64),
        ('R9',  ctypes.c_uint64),
        ('R10', ctypes.c_uint64),
        ('R11', ctypes.c_uint64),
        ('R12', ctypes.c_uint64),
        ('R13', ctypes.c_uint64),
        ('R14', ctypes.c_uint64),
        ('R15', ctypes.c_uint64),
        ('Rip', ctypes.c_uint64),
        ('Header', M128A * 2),
        ('Legacy', M128A * 8),
        ('Xmm0', M128A),
        ('Xmm1', M128A),
        ('Xmm2', M128A),
        ('Xmm3', M128A),
        ('Xmm4', M128A),
        ('Xmm5', M128A),
        ('Xmm6', M128A),
        ('Xmm7', M128A),
        ('Xmm8', M128A),
        ('Xmm9', M128A),
        ('Xmm10', M128A),
        ('Xmm11', M128A),
        ('Xmm12', M128A),
        ('Xmm13', M128A),
        ('Xmm14', M128A),
        ('Xmm15', M128A),
    ]

class EXCEPTION_RECORD(ctypes.Structure):
    pass

EXCEPTION_RECORD._fields_ = [
    ('ExceptionCode', wintypes.DWORD),
    ('ExceptionFlags', wintypes.DWORD),
    ('ExceptionRecord', ctypes.POINTER(EXCEPTION_RECORD)),
    ('ExceptionAddress', ctypes.c_void_p),
    ('NumberParameters', wintypes.DWORD),
    ('ExceptionInformation', ctypes.c_uint64 * 15),
]

class EXCEPTION_DEBUG_INFO(ctypes.Structure):
    _fields_ = [
        ('ExceptionRecord', EXCEPTION_RECORD),
        ('dwFirstChance', wintypes.DWORD),
    ]

class DEBUG_EVENT_UNION(ctypes.Union):
    _fields_ = [
        ('Exception', EXCEPTION_DEBUG_INFO),
        ('padding', ctypes.c_byte * 160)
    ]

class DEBUG_EVENT(ctypes.Structure):
    _fields_ = [
        ('dwDebugEventCode', wintypes.DWORD),
        ('dwProcessId', wintypes.DWORD),
        ('dwThreadId', wintypes.DWORD),
        ('u', DEBUG_EVENT_UNION),
    ]

# ==========================================
# CLASE PRINCIPAL DEL DEPURADOR INTEL I5
# ==========================================

class DepuradorIntelI5:
    def __init__(self, pid):
        self.pid = int(pid)
        self.depurando = False

    def acoplar_proceso(self):
        """
        Se conecta al proceso en ejecución usando la API de Windows.
        """
        print(f"[*] Intentando acoplar al proceso objetivo PID: {self.pid}...")
        if kernel32.DebugActiveProcess(self.pid):
            self.depurando = True
            print(f"[+] ¡Acoplado con éxito al PID {self.pid}!")
            return True
        else:
            print(f"[-] Error al acoplar. Código de error Windows: {kernel32.GetLastError()}")
            return False

    def obtener_registros_cpu(self, thread_id):
        """
        Lee e imprime el estado de los registros del procesador Intel i5 (x86_64).
        """
        h_thread = kernel32.OpenThread(THREAD_ALL_ACCESS, False, thread_id)
        if not h_thread:
            print("[-] No se pudo abrir el hilo para leer registros.")
            return

        ctx = CONTEXT64()
        ctx.ContextFlags = CONTEXT_FULL_AMD64

        if kernel32.GetThreadContext(h_thread, ctypes.byref(ctx)):
            print("\n" + "="*50)
            print("     ESTADO DE REGISTROS INTEL x86_64 (CPU)")
            print("="*50)
            print(f" RIP (Instruction Pointer): 0x{ctx.Rip:016X}")
            print(f" RSP (Stack Pointer):       0x{ctx.Rsp:016X}")
            print(f" RBP (Base Pointer):        0x{ctx.Rbp:016X}")
            print(f" RAX: 0x{ctx.Rax:016X} | RBX: 0x{ctx.Rbx:016X}")
            print(f" RCX: 0x{ctx.Rcx:016X} | RDX: 0x{ctx.Rdx:016X}")
            print(f" RSI: 0x{ctx.Rsi:016X} | RDI: 0x{ctx.Rdi:016X}")
            print("="*50 + "\n")
        else:
            print("[-] Error al obtener el contexto del hilo.")

        kernel32.CloseHandle(h_thread)

    def bucle_depuracion(self):
        """
        Bucle persistente que procesa eventos e inspecciona registros en excepciones.
        """
        debug_event = DEBUG_EVENT()
        print("[*] Bucle de depuración activo en Intel i5. Presiona Ctrl+C para detener.\n")

        try:
            while self.depurando:
                if kernel32.WaitForDebugEvent(ctypes.byref(debug_event), 1000):
                    codigo = debug_event.dwDebugEventCode
                    tid = debug_event.dwThreadId
                    pid = debug_event.dwProcessId

                    if codigo == EXCEPTION_DEBUG_EVENT:
                        exc_record = debug_event.u.Exception.ExceptionRecord
                        print(f"[!] EVENTO DE EXCEPCIÓN en Hilo: {tid}")
                        print(f"    -> Código Excepción: {hex(exc_record.ExceptionCode)}")
                        print(f"    -> Dirección:        {hex(exc_record.ExceptionAddress if exc_record.ExceptionAddress else 0)}")
                        
                        # Inspeccionar registros de la CPU Intel i5
                        self.obtener_registros_cpu(tid)

                    elif codigo == EXIT_PROCESS_DEBUG_EVENT:
                        print(f"[!] El proceso {pid} ha finalizado.")
                        self.depurando = False

                    kernel32.ContinueDebugEvent(pid, tid, DBG_CONTINUE)

        except KeyboardInterrupt:
            print("\n[*] Interrupción detectada. Desacoplando depurador...")
            self.desacoplar_proceso()

    def desacoplar_proceso(self):
        """
        Libera el proceso objetivo limpiamente.
        """
        if kernel32.DebugActiveProcessStop(self.pid):
            print(f"[+] Depurador desacoplado del PID {self.pid}.")
        self.depurando = False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python depurador_intel_i5.py <PID_del_Proceso>")
        sys.exit(1)

    depurador = DepuradorIntelI5(sys.argv[1])
    if depurador.acoplar_proceso():
        depurador.bucle_depuracion()
