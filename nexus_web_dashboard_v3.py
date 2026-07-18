# ... (importaciones anteriores) ...

@app.route('/')
def index():
    # 1. Obtener Nivel de Batería (Moto E13)
    battery_level = int(subprocess.getoutput("cat /sys/class/power_supply/battery/capacity"))
    is_charging = subprocess.getoutput("cat /sys/class/power_supply/battery/status") == "Charging"
    
    # 2. Alerta Crítica (Hardware)
    if battery_level <= 20 and not is_charging:
        subprocess.run(["termux-tts-speak", "Atención. Batería crítica. Conecta el cargador al Moto E Trece."])
        subprocess.run(["termux-vibrate", "-d", "1000"])

    # ... (lógica de Temp, Geo y BTC igual que antes) ...

    # Estilo dinámico para la batería
    bat_class = "alert" if battery_level <= 20 else "status-ok"
    
    # HTML Actualizado con el Monitor de Energía
    NEW_HTML = f"""
    <div class="box {bat_class}">
        <h3>🔋 ENERGÍA: {battery_level}% {'(Cargando)' if is_charging else '(Descargando)'}</h3>
        { '<p>⚠️ CONECTA EL CARGADOR AHORA</p>' if battery_level <= 20 else '' }
    </div>
    """
    # ... (renderizado del resto del Dashboard) ...
