import nikto
import tkinter as tk
from tkinter import messagebox
import os
import subprocess

def start_sentry():
    subprocess.Popen(["lxterminal", "-e", "bash", "/root/nexus_sentry.sh"])
    messagebox.showinfo("Nexus", "Sentry activado: Capturando tráfico...")

def check_alerts():
    subprocess.Popen(["lxterminal", "-e", "tail", "-f", "/root/Nexus_Captures/alerts.log"])

def clean_system():
    os.system("rm -rf /tmp/.X* && apt clean")
    messagebox.showinfo("Nexus", "Limpieza de temporales completada.")

root = tk.Tk()
root.title("NEXUS - Mobile Audit Platform")
root.geometry("300x400")

label = tk.Label(root, text="CENTRO DE MANDO NEXUS", font=("Courier", 12, "bold"))
label.pack(pady=20)

# Botones grandes para uso táctil
tk.Button(root, text="ACTIVAR SENTRY", command=start_sentry, height=2, width=25, bg="green", fg="white").pack(pady=5)
tk.Button(root, text="VER ALERTAS", command=check_alerts, height=2, width=25, bg="orange").pack(pady=5)
tk.Button(root, text="LIMPIEZA (TMP)", command=clean_system, height=2, width=25, bg="red", fg="white").pack(pady=5)

root.mainloop()
