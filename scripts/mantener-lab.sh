#!/data/data/com.termux/files/usr/bin/bash
set -u

LAB="$HOME"
LOG="$HOME/mantenimiento-lab.log"
REPORT="$HOME/mantenimiento-lab.txt"

# Colores
BOLD='\033[1m'
RESET='\033[0m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'

log() {
    printf '%s\n' "$*" | tee -a "$LOG"
}

title() {
    echo
    printf "${BOLD}${CYAN}===== %s =====${RESET}\n" "$1"
    printf '\n===== %s =====\n' "$1" >> "$REPORT"
}

is_git_repo() {
    [ -d "$1/.git" ] || [ -f "$1/.git" ]
}

update_repo() {
    local dir="$1"
    local name
    name="$(basename "$dir")"

    echo
    printf "${CYAN}[%s]${RESET}\n" "$name"

    if ! is_git_repo "$dir"; then
        printf "  - No es repositorio Git\n"
        return 0
    fi

    cd "$dir" || return 1

    printf "  Rama: "
    git branch --show-current 2>/dev/null || echo "desconocida"

    printf "  Estado: "
    if git diff --quiet && git diff --cached --quiet; then
        echo "limpio"
    else
        printf "${YELLOW}CAMBIOS LOCALES${RESET}\n"
    fi

    if ! git remote get-url origin >/dev/null 2>&1; then
        printf "  ${YELLOW}Sin remote origin; no se actualiza${RESET}\n"
        return 0
    fi

    printf "  Remote: "
    git remote get-url origin 2>/dev/null

    echo "  Actualizando..."

    if git pull --ff-only 2>&1; then
        printf "  ${GREEN}OK${RESET}\n"
    else
        printf "  ${YELLOW}No se pudo actualizar con fast-forward${RESET}\n"
        printf "  No se hizo merge automático.\n"
    fi
}

write_report() {
    {
        echo "========================================"
        echo " INVENTARIO DEL LABORATORIO"
        echo " Fecha: $(date)"
        echo " Host: $(hostname 2>/dev/null || echo Android)"
        echo "========================================"
        echo

        echo "DIRECTORIOS"
        echo "-----------"

        for item in "$LAB"/*; do
            [ -e "$item" ] || continue
            basename "$item"
        done

        echo
        echo "REPOSITORIOS GIT"
        echo "----------------"

        for item in "$LAB"/*; do
            [ -e "$item" ] || continue

            if is_git_repo "$item"; then