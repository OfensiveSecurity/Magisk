from flask import Flask, render_template_string, redirect, url_for
import subprocess

app = Flask(__name__)

# Plantilla con el Botón de Pánico Rojo
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>NEXUS CORE v3.2 - Dashboard</title>
    <meta http-equiv="refresh" content="10">
    <style>
        body { background: #0a0a0a; color: #00ff41; font-family: 'Courier New', monospace; padding: 20px; text-align: center; }
        .box { border: 1px solid #00ff41; padding: 15px; margin: 10px auto; width: 300px; border-radius: 5px; }
        .alert { color: #ff0000; font-weight: bold; border: 2px solid #ff0000; background: #200000; }
        .panic-btn { background: #ff0000; color: white; padding: 20px; border: none; border-radius: 10px; cursor: pointer; font-weight: bold; font-size: 1.2em; width: 100%; margin-top: 20px; }
        .panic-btn:hover { background: #cc0000; }
    </style>
</head>
<body>
    <h1>[►] NEXUS CORE: MOTO E13</h1>
    
    <div class="box">
        <h3>🔥 TEMP: {{ temp }}°C</h3>
    </div>

    <div class="box {{ 'alert' if country != 'Mexico' else '' }}">
        <h3>📡 GEO: {{ country }}</h3>
        <p>IP: {{ ip }}</p>
    </div>

    <div class="box">
        <form action="/panic" method="post">
            <button type="submit" class="panic-btn">⚠ BOTÓN DE PÁNICO (KILL-NET)</button>
        </form>
    </div>
</body>
</html>
"""

@app.route('/')
def index():
    # Obtener Temperatura y Geo (Simplificado para el ejemplo)
    temp = subprocess.getoutput("cat /sys/class/thermal/thermal_zone0/temp | awk '{print $1/1000}'")
    country = subprocess.getoutput("curl -s --max-time 1 https://ipapi.co/country_name/")
    ip = subprocess.getoutput("curl -s --max-time 1 https://ipapi.co/ip/")
    return render_template_string(HTML_TEMPLATE, temp=temp, country=country, ip=ip)

@app.route('/panic', methods=['POST'])
def panic():
    # Ejecuta el script de bloqueo de red (Modo Avión)
    subprocess.run(["bash", "/data/data/com.termux/files/home/scripts/nexus_network_kill.sh"])
    return "<h1>SISTEMA BLOQUEADO. REVISA EL MOTO E13.</h1><br><a href='/'>Volver</a>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
