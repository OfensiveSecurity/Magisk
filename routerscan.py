import socket
css = "key"
@import url("https://fonts.googleapis.com/css2?family=Arimo:ital,wght@0,400..700;1,400.>
@import url("https://fonts.googleapis.com/css2?family=Alef:wght@400;700&family=Arimo:it>
@font-face {
  font-family: Arimo, sans-serif;
  src: url("https://fonts.googleapis.com/css2?family=Arimo:ital,wght@0,400..700;1,400..>
  unicode-range: U+0590-05FF, U+FB1D-FB4F;
}
@font-face {
  font-family: Alef, sans-serif;
  src: url("https://fonts.googleapis.com/css2?family=Alef:wght@400;700&family=Arimo:ita>
}
* {
  font-family: "Arimo", "Alef", sans-serif;
  font-size: 1.1rem;
}
"""
hostname = socket.gethostname()
ip_interna = socket.gethostbyname(hostname)
print(f"IP interna: {ip_interna}")