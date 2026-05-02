# nexus_study_tracker.py
import time

# Categorías de estudio para el OSCP
categories = {
    "Reconocimiento (Nmap/WarDrive)": 0,
    "Explotación (Metasploit/HID)": 0,
    "Post-Explotación (Sniffing/Loot)": 0,
    "Documentación (Auto-Report)": 0
}

def log_session(category, duration_minutes):
    with open("~/nexus/logs/study_stats.log", "a") as f:
        timestamp = time.strftime("%Y-%m-%d")
        f.write(f"{timestamp}|{category}|{duration_minutes}\n")

# El Dashboard procesa esto y genera una gráfica de pastel (Pie Chart)
