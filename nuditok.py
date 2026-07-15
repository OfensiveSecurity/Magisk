from http.server import HTTPServer, BaseHTTPRequestHandler
import ssl
MESSAGE = """Hola amor como estás? Cómo Quieres que te desleche hoy?😏[>
Estoy disponible para videollamada, sexting, videos personalizados, fet>
(ENCUENTROS ÚNICAMENTE CON CLIENTE FRECUENTES DE CONFIANZA😈🔥)
Dime de qué país eres y qué método de pago usas amor 💕
Acepto transferencia de México, Argentina, PayPal, Binance y Meru
(otros métodos de pago con costo extra con mi casa de cambio)
Canal de referencias:
https://t.me/ghotevy99
"""
class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(MESSAGE.encode("utf-8"))
httpd = HTTPServer(("0.0.0.0", 443), Handler)
# Requiere un certificado y una clave SSL
httpd.socket = ssl.wrap_socket(
    httpd.socket,
    certfile="cert.pem",
    keyfile="key.pem",
    server_side=True
)
print("Servidor HTTPS escuchando en el puerto 443...")
httpd.serve_forever()