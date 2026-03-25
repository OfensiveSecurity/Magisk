import psutil
import requests
import matplotlib.pyplot as plt
from datetime import datetime
import time

# Configuración
SAMPLES = 20
INTERVAL = 5 # segundos
cpu_usage = []
btc_prices = []
timestamps = []

print(f"[*] NEXUS CORE: Iniciando correlación CPU vs BTC...")

try:
    for i in range(SAMPLES):
        # 1. Obtener métricas del Moto E13
        cpu = psutil.cpu_percent(interval=None)
        
        # 2. Obtener precio de BTC desde Binance
        response = requests.get("https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")
        price = float(response.json()['price'])
        
        # 3. Almacenar datos
        cpu_usage.append(cpu)
        btc_prices.append(price)
        timestamps.append(datetime.now().strftime('%H:%M:%S'))
        
        print(f"[{i+1}/{SAMPLES}] CPU: {cpu}% | BTC: ${price}")
        time.sleep(INTERVAL)

    # --- Generación de Gráfica ---
    fig, ax1 = plt.subplots(figsize=(10, 5))

    # Eje CPU (Izquierda)
    ax1.set_xlabel('Tiempo (H:M:S)')
    ax1.set_ylabel('Uso de CPU %', color='tab:red')
    ax1.plot(timestamps, cpu_usage, color='tab:red', label='CPU Moto E13', linewidth=2)
    ax1.tick_params(axis='y', labelcolor='tab:red')

    # Eje BTC (Derecha)
    ax2 = ax1.twinx()
    ax2.set_ylabel('BTC Price (USDT)', color='tab:blue')
    ax2.plot(timestamps, btc_prices, color='tab:blue', label='Precio BTC', linestyle='--')
    ax2.tick_params(axis='y', labelcolor='tab:blue')

    plt.title('NEXUS SYSTEM: Correlación Hardware vs Mercado')
    plt.xticks(rotation=45)
    fig.tight_layout()
    
    # Guardar en el dashboard
    plt.savefig('/data/data/com.termux/files/home/nexus/dashboard/correlation_live.png')
    print("[✓] Gráfica generada en: /nexus/dashboard/correlation_live.png")

except Exception as e:
    print(f"[!] Error en el sensor: {e}")
