import socket
import subprocess
# Detectar tu IP primero
hostname = socket.gethostname()
local_ip = socket.gethostbyname(hostname)
print(f"Tu IP: {local_ip}")
