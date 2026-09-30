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