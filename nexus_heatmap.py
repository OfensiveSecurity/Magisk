import matplotlib.pyplot as plt
import re

# 1. Leer la bitácora de patrullaje
with open("nexus_sentry.log", "r") as f:
    data = f.read()

# 2. Extraer tiempos y valores de RSSI (Ej: -45 dBm)
times = re.findall(r"\[(.*?)\]", data)
signals = [int(s) for s in re.findall(r"Señal:.*?(-?\d+)", data)]

# 3. Generar el Gráfico de Proximidad
plt.figure(figsize=(10, 5))
plt.plot(signals, color='lime', linewidth=2)
plt.fill_between(range(len(signals)), signals, -100, color='lime', alpha=0.3)
plt.title("NEXUS CORE - MAPA DE CALOR DE SEÑAL (NAUCALPAN)")
plt.ylabel("Potencia (dBm)")
plt.xlabel("Puntos de Muestreo (Tiempo)")
plt.grid(color='gray', linestyle='--', alpha=0.5)

# 4. Guardar para el Dashboard
plt.savefig("heatmap.png", transparent=True)
print("[✓] Mapa de calor generado en 'heatmap.png'")
