# nexus_report_gen.py
import datetime

def update_report(step_type, description, evidence):
    with open("~/nexus/reports/OSCP_Draft.md", "a") as f:
        timestamp = datetime.datetime.now().strftime("%H:%M")
        f.write(f"### [{timestamp}] {step_type}\n")
        f.write(f"- **Descripción:** {description}\n")
        f.write(f"- **Evidencia:** `{evidence}`\n\n")

# Ejemplo: update_report("Enumeración", "Escaneo Nmap detectó puerto 80 abierto", "nmap -sV 10.10.10.5")
