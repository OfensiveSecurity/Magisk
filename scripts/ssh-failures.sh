cat > ssh-failures.sh <<'EOF'
#!/usr/bin/env bash

LOG="${1:-/var/log/auth.log}"

if [[ ! -r "$LOG" ]]; then
    echo "No se puede leer: $LOG" >&2
    exit 1
fi

awk '/Failed password/ {print $(NF-3)}' "$LOG" |
    sort |
    uniq -c |
    sort -rn |
    head -10
EOF

chmod +x ssh-failures.sh