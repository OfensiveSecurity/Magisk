cat > ~/lab/scripts/f1-build-diagnostic.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

set -u

echo "=== F1 BUILD DIAGNOSTIC ==="

printf '\n[CPU]\n'
nproc 2>/dev/null || true
uname -m 2>/dev/null || true

printf '\n[MEMORIA]\n'
free -h 2>/dev/null || true

printf '\n[ALMACENAMIENTO]\n'
df -h "$HOME" 2>/dev/null || true

printf '\n[COMPILADORES]\n'
command -v clang 2>/dev/null && clang --version | head -1
command -v gcc 2>/dev/null && gcc --version | head -1
command -v g++ 2>/dev/null && g++ --version | head -1

printf '\n[CMAKE]\n'
command -v cmake 2>/dev/null && cmake --version | head -1

printf '\n[NINJA]\n'
command -v ninja 2>/dev/null && ninja --version

printf '\n[GIT]\n'
command -v git 2>/dev/null && git --version

printf '\n[ABI]\n'
getprop ro.product.cpu.abilist 2>/dev/null || true

printf '\n[TERMUX]\n'
printf 'PREFIX=%s\n' "${PREFIX:-unknown}"
printf 'TMPDIR=%s\n' "${TMPDIR:-unknown}"

echo
echo "=== FIN ==="
exit 0
EOF

chmod +x ~/lab/scripts/f1-build-diagnostic.sh
~/lab/scripts/f1-build-diagnostic.sh