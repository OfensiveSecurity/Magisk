#!/bin/bash

REPORT_FILE="/data/data/com.termux/files/home/nexus/exam_evidence/OSCP-Report-Draft.md"

cat <<EOF > "$REPORT_FILE"
# 🛡️ OSCP EXAM REPORT - NEXUS CORE DRAFT
**ID de Estudiante:** [TU-ID-AQUÍ]
**Fecha de Inicio:** \$(date +%d/%m/%Y)
**Estado del Reloj:** Ver 'nexus-status'

---

## 🏗️ 1. METODOLOGÍA GENERAL
* **Enumeración:** Nmap optimizado (1500 pps).
* **Explotación:** [Manual/Metasploit].
* **Post-Explotación:** Recolección de evidencias automática vía Nexus Sync.

---

## 💻 MÁQUINA 1: [NOMBRE/IP]
### 🔍 Enumeración
\`\`\`bash
# Insertar comando nmap aquí
\`\`\`

### 🔓 Explotación
* **Vulnerabilidad:** [Ej. RCE en servicio HTTP]
* **Vector de Ataque:** [Descripción breve]

### 🚩 Flags
* **Local.txt:** \`cat local.txt\` -> [Pegar Hash]
* **Proof.txt:** \`cat proof.txt\` -> [Pegar Hash]

---

## 📸 LISTA DE CAPTURAS REQUERIDAS
- [ ] IPConfig / Ifconfig del atacante y víctima.
- [ ] Contenido de local.txt con el shell activo.
- [ ] Contenido de proof.txt con privilegios de root/system.
EOF

echo "[✓] Plantilla generada en: $REPORT_FILE"
