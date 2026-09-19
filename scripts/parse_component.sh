#!/data/data/com.termux/files/usr/bin/bash
# Guardamos el JSON de la pregunta en un archivo temporal local
cat << 'EOF' > plata_layout.json
{"WsHeader2-olbm8q":{"type":{"resolvedName":"WsHeader2"}},"Dauk-9xXbU":{"type":{"resolvedName":"WsBafHero"},"props":{"blockId":"ws-baf-hero","chips":{"label":"Te invita"},"text>
EOF
echo "========================================="
echo "  PROCESANDO LAYOUT EN MODO ROOTLESS     "
echo "========================================="
# 1. Extraer los IDs de los bloques disponibles en el JSON
echo -e "\n[+] Bloques de componentes identificados:"
jq -r 'keys[]' plata_layout.json
# 2. Extraer textos de beneficios específicos usando filtros de jq
echo -e "\n[+] Beneficios financieros encontrados:"
# Nota: En tu JSON original la ruta exacta se procesa mapeando el array de objetos internos
jq -r '.. | .benefits? // empty | .[] | "- " + .heading' plata_layout.json 2>/dev/null | sed 's/<[^>]*>//g'
# Limpieza del entorno de ejecución
rm plata_layout.json
