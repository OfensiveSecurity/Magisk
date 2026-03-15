import os


def check_nexus_status():
    print("--- CHECK DE ESTADO NEXUS v3.0 ---")
    
    # 1. Verificar SELinux (Gracias al módulo Magisk)
    selinux = os.popen("getenforce").read().strip()
    print(f"[+] Estado de SELinux: {selinux}")
    
    # 2. Verificar Binario C++
    if os.path.exists("./nexus_tool"):
        print("[+] Binario C++: Detectado y compilado.")
    else:
        print("[-] Binario C++: No encontrado. Ejecuta g++ primero.")

    # 3. Verificar GPU
    if os.path.exists("/dev/mali0") or os.path.exists("/dev/kgsl-3d0"):
        print("[+] Hardware GPU: Accesible para OpenCL.")

if __name__ == "__main__":
    check_nexus_status()