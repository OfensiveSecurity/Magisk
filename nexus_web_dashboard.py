from flask import Flask, render_template_string
import subprocess
import os

app = Flask(__name__)

# Plantilla HTML con estilo Dark Mode de Nexus
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>NEXUS CORE v3.2 - Dashboard</title>
    <meta http-equiv="refresh" content="10"> <style>
        body { background: #0a0a0a; color: #00ff41; font-family: 'Courier New', monospace; padding: 20px; }
        .box { border: 1px solid #00ff41; padding: 15px; margin-bottom: 10px; border-radius: 5px; }
        .alert { color: #ff0000; font-weight: bold; border-color: #ff0000; }
        h1 { border-bottom: 2px solid #00ff41; padding-bottom: 10px; }
        .status-ok { color: #00ff41; }
        .status-warn { color: #ff9900; }
    </style>
</head>
<body>
    <h1>[►] NEXUS CORE: MOTO E13 MONITOR</h1>
    
    <div class="box">
        <h3>🔥 ESTADO TÉRMICO</h3>
        <p>Temperatura: {{ temp }}°C</p>
        <p>Límite Actual: {{ temp_limit }}°C</p>
    </div>

    <div class="box {{ 'alert' if country != 'Mexico' else '' }}">
        <h3>📡 GEOLOCALIZACIÓN (Anti-403)</h3>
        <p>IP Pública: {{ ip }}</p>
        <p>País Detectado: <b>{{ country }}</b></p>
        {% if country != "Mexico" %}<p>[!] RIESGO DE BLOQUEO SAT DETECTADO</p>{% endif %}
    </div>

    <div class="box">
        <h3>⏱️ EXAMEN PEN-200</h3>
        <p>{{ exam_timer }}</p>
    </div>

    <div class="box">
        <h3>💰 MERCADO (BTC)</h3>
        <p>Precio Actual: ${{ btc_price }} USD</p>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    # Obtener Temperatura
    temp = subprocess.getoutput("cat /sys/class/thermal/thermal_zone0/temp | awk '{print $1/1000}'")
    # Obtener IP y País
    geo_data = subprocess.getoutput("curl -s --max-time 2 https://ipapi.co/json/").splitlines()
    country = "Desconocido"
    ip = "No-Net"
    for line in geo_data:
        if "country_name" in line: country = line.split(":")[1].replace('"', '').replace(',', '').strip()
        if "ip" in line and "version" not in line: ip = line.split(":")[1].replace('"', '').replace(',', '').strip()
    
    # Obtener Reloj de Examen
    exam_timer = subprocess.getoutput("bash ~/scripts/nexus_clock.sh")
    # Precio BTC (Simulado o vía API previa)
    btc_price = subprocess.getoutput("cat ~/nexus/logs/btc_last.tmp 2>/dev/null || echo 'Cargando...'")

    return render_template_string(HTML_TEMPLATE, temp=temp, temp_limit="48", country=country, ip=ip, exam_timer=exam_timer, btc_price=btc_price)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
