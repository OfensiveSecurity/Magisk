#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Security Research Repository - Name Migration
# ============================================================
# Ejecutar desde la raíz del repositorio:
#   bash migrate-repo-names.sh
#
# El script:
#   1. Comprueba que estamos dentro de un repositorio Git.
#   2. Comprueba que no haya cambios sin guardar.
#   3. Renombra carpetas y archivos con git mv.
#   4. Actualiza referencias conocidas en README.md.
#   5. Muestra el diff final.
# ============================================================

ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "ERROR: ejecuta este script dentro de un repositorio Git."
    exit 1
}

cd "$ROOT"

echo "Repositorio: $ROOT"

if [[ -n "$(git status --porcelain)" ]]; then
    echo
    echo "ERROR: hay cambios sin guardar."
    echo "Guárdalos o haz commit antes de continuar:"
    echo
    git status --short
    exit 2
fi

echo
echo "== Comprobando estructura =="

[[ -d tools ]] || {
    echo "ERROR: no existe tools/"
    exit 3
}

mkdir -p tools/assessment
mkdir -p tools/reconnaissance
mkdir -p tools/utilities
mkdir -p case-studies

rename_git() {
    local old="$1"
    local new="$2"

    if [[ -e "$old" ]]; then
        if [[ -e "$new" ]]; then
            echo "AVISO: destino ya existe:"
            echo "  $new"
            return 0
        fi

        echo "RENOMBRE: $old"
        echo "      -> $new"
        git mv "$old" "$new"
    else
        echo "OMITIDO: no existe $old"
    fi
}

echo
echo "== Renombrando directorios =="

rename_git "tools/exploitation" "tools/assessment"
rename_git "write-ups" "case-studies"

echo
echo "== Renombrando herramientas =="

rename_git \
    "tools/automation/bug-bounty-workflow.sh" \
    "tools/automation/security-assessment-workflow.sh"

rename_git \
    "tools/automation/recon-automation.yml" \
    "tools/automation/asset-monitoring.yml"

rename_git \
    "tools/assessment/sqli-tester.py" \
    "tools/assessment/sqli-assessment.py"

rename_git \
    "tools/assessment/xss-scanner.py" \
    "tools/assessment/xss-assessment.py"

rename_git \
    "tools/reconnaissance/subdomain-enum.py" \
    "tools/reconnaissance/asset-discovery.py"

rename_git \
    "tools/utilities/wordlist-merger.sh" \                                                                                                                                              "tools/utilities/wordlist-tool.sh"

echo
echo "== Actualizando README =="

if [[ -f README.md ]]; then
    python3 - <<'PY'
from pathlib import Path

p = Path("README.md")
text = p.read_text(encoding="utf-8")

replacements = {
    "Exploitation Tools": "Security Assessment Tools",
    "Reconnaissance Tools": "Reconnaissance & Discovery",
    "Utility Tools": "Security Utilities",

    "write-ups/": "case-studies/",

    "tools/exploitation/": "tools/assessment/",

    "tools/automation/bug-bounty-workflow.sh":
        "tools/automation/security-assessment-workflow.sh",

    "tools/automation/recon-automation.yml":
        "tools/automation/asset-monitoring.yml",

    "tools/exploitation/sqli-tester.py":
        "tools/assessment/sqli-assessment.py",

    "tools/exploitation/xss-scanner.py":
        "tools/assessment/xss-assessment.py",

    "tools/reconnaissance/subdomain-enum.py":
        "tools/reconnaissance/asset-discovery.py",

    "tools/reconnaissance/url-collector.sh":
        "tools/reconnaissance/url-analysis.sh",

    "tools/utilities/payload-generator.py":
        "tools/utilities/test-input-generator.py",

    "tools/utilities/wordlist-merger.sh":
        "tools/utilities/wordlist-tool.sh",

    "Complete Bug Bounty Automation Workflow":
        "Security Assessment Workflow",

    "Reconnaissance Automation Pipeline":
        "Asset Monitoring",

    "SQL Injection Automated Tester":
        "SQL Injection Assessment",

    "Cross-Site Scripting Scanner":
        "XSS Assessment",

    "Subdomain Enumeration Script":
        "Asset Discovery",

    "URL Collection & Analysis Tool":
        "URL Analysis",

    "Custom Payload Generator":
        "Test Input Generator",

    "Wordlist Merger & Deduplicator":
        "Wordlist Tool",
}

for old, new in replacements.items():
    text = text.replace(old, new)

p.write_text(text, encoding="utf-8")
PY
else
    echo "AVISO: README.md no existe."
fi

echo
echo "== Buscando referencias antiguas =="

if command -v rg >/dev/null 2>&1; then
    rg -n \
        'tools/exploitation|bug-bounty-workflow|recon-automation|sqli-tester|xss-scanner|subdomain-enum|url-collector|payload-generator|wordlist-merger|write-ups/' \
        . \
        --glob '!*.git/*' \
        || true
else
    grep -RniE \
        'tools/exploitation|bug-bounty-workflow|recon-automation|sqli-tester|xss-scanner|subdomain-enum|url-collector|payload-generator|wordlist-merger|write-ups/' \
        . \
        --exclude-dir=.git \
        || true
fi

echo
echo "============================================================"
echo "Migración terminada."
echo "============================================================"
echo
echo "Cambios:"
git status --short

echo
echo "Diff:"
git diff -- README.md

echo
echo "Para revisar todo:"
echo "  git status"
echo "  git diff --stat"
echo "  git diff"
echo
echo "Cuando hayas verificado todo:"
echo "  git add -A"
echo '  git commit -m "refactor: modernize security tool names"'