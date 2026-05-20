#!/bin/bash
# linux CORE - MASTER CONTROL v3.3

show_menu() {
    clear
    echo "=========================================="
    echo "      linux CORE SYSTEM v3.3 (OSCP)       "
    echo "=========================================="
    echo "[1] Levantar Base de Datos (MariaDB)"
    echo "[2] Iniciar Reconocimiento (Nexus-Recon)"
    echo "[3] Lanzar Fuzzer CAN (Logging to DB)"
    echo "[4] ACTIVAR WI-FI CORPORATIVO (RADIUS)"
    echo "[5] Ver quién está conectado (Logs)"
    echo "[6] Detener todos los servicios"
    echo "[7] Salir"
    echo "=========================================="
}

while true; do
    show_menu
    read -p "Linux > " opt
    case $opt in
        1) sudo service mariadb start && echo "[+] DB Online" ;;
        2) python3 ~/Nexus-Suite/tools/nexus-recon.py ;;
        3) python3 ~/Nexus-Suite/tools/canfuzzer.py ;;
        4) sudo service freeradius restart && echo "[+] RADIUS Online en .79">
        5) sudo tail -f /var/log/freeradius/radius.log ;;
        6) sudo service freeradius stop && sudo service mariadb stop && echo >
        7) exit 0 ;;
        *) echo "Opción no válida." ; sleep 1 ;;
    esac
    read -p "Presiona Enter para continuar..."
{
    ((${#_upvars[@]})) && _comp_unlocal "${_upvars[@]}";
    if [[ -n $_dir ]]; then
        local _original_pwd=$PWD;
        local PWD=${PWD-} OLDPWD=${OLDPWD-};
        command cd -- "$_dir" &> /dev/null || {
            _comp_compgen__error_fallback;
            return
        };
    fi;
    local _comp_compgen__append=$_append;
    local _comp_compgen__var=$_var;
    local _comp_compgen__cur=$_cur cur=$_cur;
    "${_generator[@]}" "$@";
    local _status=$?;
    [[ -n $_dir ]] && command cd -- "$_original_pwd";
    return "$_status"
}
_comp_compgen__error_fallback ()
{
    local _status=$?;
    if [[ -n $_append ]]; then
        eval -- "$_var+=()";
    else
        eval -- "$_var=()";
    fi;
    return "$_status"
}
_comp_compgen_allowed_groups ()
{
    if _comp_as_root; then
        _comp_compgen -- -g;
    else
        _comp_compgen_split -- "$(id -Gn 2> /dev/null || groups 2> /dev/null)";
    fi
}
_comp_compgen_allowed_users ()
{
    if _comp_as_root; then
        _comp_compgen -- -u;
    else
        _comp_compgen_split -- "$(id -un 2> /dev/null || whoami 2> /dev/null)";
    fi
}
_comp_compgen_available_interfaces ()
{
    local PATH=$PATH:/sbin;
    local generated;
    _comp_compgen -v generated split -- "$({ if [[ ${1-} == -w ]]; then
    iwconfig;
else
    if [[ ${1-} == -a ]]; then
        ip -c=never link show up || ip link show up || ifconfig;
    else
        ip -c=never link show || ip link show || ifconfig -a;
    fi;
fi; } 2> /dev/null | _comp_awk '/^[^ \t]/ { if ($1 ~ /^[0-9]+:/) { print $2 } else { print $1 } }')" && _comp_compgen -U generated set "${generated[@]%:}"
}
_comp_compgen_cd_devices ()
{
    _comp_compgen -c "${cur:-/dev/}" -- -f -d -X "!*/?([amrs])cd!(c-*)"
}
_comp_compgen_commands ()
{
    [[ ! -n ${cur-} ]] && shopt -q no_empty_cmd_completion && return 1;
    _comp_compgen -- -c -o plusdirs && compopt -o filenames
}
_comp_compgen_configured_interfaces ()
{
    local -a files;
    if [[ -f /etc/debian_version ]]; then
        _comp_expand_glob files '/etc/network/interfaces /etc/network/interfaces.d/*' || return 0;
        _comp_compgen -U files split -- "$(command sed -ne 's|^iface \([^ ]\{1,\}\).*$|\1|p' "${files[@]}" 2> /dev/null)";
    else
        if [[ -f /etc/SuSE-release ]]; then
            _comp_expand_glob files '/etc/sysconfig/network/ifcfg-*' || return 0;
            _comp_compgen -U files split -- "$(printf '%s\n' "${files[@]}" | command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p')";
        else
            if [[ -f /etc/pld-release ]]; then
                _comp_compgen -U files split -- "$(command ls -B /etc/sysconfig/interfaces | command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p')";
            else
                _comp_expand_glob files '/etc/sysconfig/network-scripts/ifcfg-*' || return 0;
                _comp_compgen -U files split -- "$(printf '%s\n' "${files[@]}" | command sed -ne 's|.*ifcfg-\([^*].*\)$|\1|p')";
            fi;
        fi;
    fi
}
_comp_compgen_dvd_devices ()
{
    _comp_compgen -c "${cur:-/dev/}" -- -f -d -X "!*/?(r)dvd*"
}
_comp_compgen_filedir ()
{
    _comp_compgen_tilde && return;
    local -a toks;
    local _arg=${1-};
    if [[ $_arg == -d ]]; then
        _comp_compgen -v toks -- -d;
    else
        local REPLY;
        _comp_quote_compgen "${cur-}";
        local _quoted=$REPLY;
        _comp_unlocal REPLY;
        [[ $_quoted == "''" ]] && _quoted="";
        local _xspec=${_arg:+"!*.@($_arg|${_arg^^})"} _plusdirs=();
        local _opts=(-f -X "$_xspec");
        [[ -n $_xspec ]] && _plusdirs=(-o plusdirs);
        [[ -n ${BASH_COMPLETION_FILEDIR_FALLBACK-} || ! -n ${_plusdirs-} ]] || _opts+=("${_plusdirs[@]}");
        _comp_compgen -v toks -c "$_quoted" -- "${_opts[@]}";
        [[ -n ${BASH_COMPLETION_FILEDIR_FALLBACK-} && -n $_arg && ${#toks[@]} -lt 1 ]] && _comp_compgen -av toks -c "$_quoted" -- -f ${_plusdirs+"${_plusdirs[@]}"};
    fi;
    if ((${#toks[@]} != 0)); then
        if [[ $cur != ?(*/).. ]]; then
            _comp_compgen -Rv toks -- -X '?(*/)@(.|..)' -W '"${toks[@]}"';
        fi;
    fi;
    if ((${#toks[@]} != 0)); then
        compopt -o filenames 2> /dev/null;
    fi;
    local IFS='
';
    _comp_compgen -U toks set ${toks[@]+"${toks[@]}"}
}
_comp_compgen_filedir_xspec ()
{
    _comp_compgen_tilde && return;
    local REPLY;
    _comp_quote_compgen "$cur";
    local quoted=$REPLY;
    local xspec=${_comp_xspecs[${1##*/}]-${_xspecs[${1##*/}]-}};
    local -a toks;
    _comp_compgen -v toks -c "$quoted" -- -d;
    eval xspec="${xspec}";
    local matchop=!;
    if [[ $xspec == !* ]]; then
        xspec=${xspec#!};
        matchop=@;
    fi;
    xspec="$matchop($xspec|${xspec^^})";
    _comp_compgen -av toks -c "$quoted" -- -f -X "@(|!($xspec))";
    [[ -n ${BASH_COMPLETION_FILEDIR_FALLBACK-} && ${#toks[@]} -lt 1 ]] && _comp_compgen -av toks -c "$quoted" -- -f;
    ((${#toks[@]})) || return 1;
    if [[ $cur != ?(*/).. ]]; then
        _comp_compgen -Rv toks -- -X '?(*/)@(.|..)' -W '"${toks[@]}"' || return 1;
    fi;
    compopt -o filenames;
    _comp_compgen -RU toks -- -W '"${toks[@]}"'
}
_comp_compgen_fstypes ()
{
    local _fss;
    if [[ -e /proc/filesystems ]]; then
        _fss="$(cut -d' ' -f2 /proc/filesystems)
             $(_comp_awk '! /\*/ { print $NF }' /etc/filesystems 2> /dev/null)";
    else
        _fss="$(_comp_awk '/^[ \t]*[^#]/ { print $3 }' /etc/fstab 2> /dev/null)
             $(_comp_awk '/^[ \t]*[^#]/ { print $3 }' /etc/mnttab 2> /dev/null)
             $(_comp_awk '/^[ \t]*[^#]/ { print $4 }' /etc/vfstab 2> /dev/null)
             $(_comp_awk '{ print $1 }' /etc/dfs/fstypes 2> /dev/null)
             $(lsvfs 2> /dev/null | _comp_awk '$1 !~ /^(Filesystem|[^a-zA-Z])/ { print $1 }')
             $([[ -d /etc/fs ]] && command ls /etc/fs)";
    fi;
    [[ -n $_fss ]] && _comp_compgen_split -- "$_fss"
}
_comp_compgen_gids ()
{
    if type getent &> /dev/null; then
        _comp_compgen_split -- "$(getent group | cut -d: -f3)";
    else
        if type perl &> /dev/null; then
            _comp_compgen_split -- "$(perl -e 'while (($gid) = (getgrent)[2]) { print $gid . "\n" }')";
        else
            _comp_compgen_split -- "$(cut -d: -f3 /etc/group)";
        fi;
    fi
}
_comp_compgen_help ()
{
    (($#)) || set -- -- --help;
    local -a _lines;
    _comp_compgen_help__get_help_lines "$@" || return "$?";
    local -a options=();
    local _line;
    for _line in "${_lines[@]}";
    do
        [[ $_line == *([[:blank:]])-* ]] || continue;
        while [[ $_line =~ ((^|[^-])-[A-Za-z0-9?][[:space:]]+)\[?[A-Z0-9]+([,_-]+[A-Z0-9]+)?(\.\.+)?\]? ]]; do
            _line=${_line/"${BASH_REMATCH[0]}"/"${BASH_REMATCH[1]}"};
        done;
        _comp_compgen_help__parse "${_line// or /, }";
    done;
    ((${#options[@]})) || return 1;
    _comp_compgen -U options -- -W '"${options[@]}"';
    return 0
}
_comp_compgen_help__get_help_lines ()
{
    local -a help_cmd;
    case ${1-} in
        -)
            if (($# > 1)); then
                printf 'bash_completion: %s -: extra arguments for -\n' "${FUNCNAME[1]}" 1>&2;
                printf 'usage: %s -\n' "${FUNCNAME[1]}" 1>&2;
                printf 'usage: %s -c cmd args...\n' "${FUNCNAME[1]}" 1>&2;
                printf 'usage: %s [-- args...]\n' "${FUNCNAME[1]}" 1>&2;
                return 2;
            fi;
            help_cmd=(exec cat)
        ;;
        -c)
            if (($# < 2)); then
                printf 'bash_completion: %s -c: no command is specified\n' "${FUNCNAME[1]}" 1>&2;
                printf 'usage: %s -\n' "${FUNCNAME[1]}" 1>&2;
                printf 'usage: %s -c cmd args...\n' "${FUNCNAME[1]}" 1>&2;
                printf 'usage: %s [-- args...]\n' "${FUNCNAME[1]}" 1>&2;
                return 2;
            fi;
            help_cmd=("${@:2}")
        ;;
        --)
            shift 1
        ;&
        *)
            local REPLY;
            _comp_dequote "${comp_args[0]-}" || REPLY=${comp_args[0]-};
            help_cmd=("${REPLY:-false}" "$@")
        ;;
    esac;
    local REPLY;
    _comp_split -l REPLY "$(LC_ALL=C "${help_cmd[@]}" 2>&1)" && _lines=("${REPLY[@]}")
}
_comp_compgen_help__parse ()
{
    local option option2 i;
    option=;
    local -a array;
    if _comp_split -F '
,/|' array "$1"; then
        for i in "${array[@]}";
        do
            case "$i" in
                ---*)
                    break
                ;;
                --?*)
                    option=$i;
                    break
                ;;
                -?*)
                    [[ -n $option ]] || option=$i
                ;;
                *)
                    break
                ;;
            esac;
        done;
    fi;
    [[ -n $option ]] || return 1;
    if [[ $option =~ (\[((no|dont)-?)\]). ]]; then
        option2=${option/"${BASH_REMATCH[1]}"/};
        option2=${option2%%[<{().[]*};
        options+=("${option2/=*/=}");
        option=${option/"${BASH_REMATCH[1]}"/"${BASH_REMATCH[2]}"};
    fi;
    [[ $option =~ ^([^=<{().[]|\.[A-Za-z0-9])+=? ]] && options+=("$BASH_REMATCH")
}
_comp_compgen_inserted_kernel_modules ()
{
    _comp_compgen -c "${1:-$cur}" split -- "$(PATH="$PATH:/sbin" lsmod | _comp_awk '{if (NR != 1) print $1}')"
}
_comp_compgen_ip_addresses ()
{
    local _n;
    case ${1-} in
        -a)
            _n='6\{0,1\}'
        ;;
        -6)
            _n='6'
        ;;
        *)
            _n=
        ;;
    esac;
    local PATH=$PATH:/sbin;
    local addrs;
    _comp_compgen -v addrs split -- "$({ ip -c=never addr show || ip addr show || LC_ALL=C ifconfig -a; } 2> /dev/null | command sed -e 's/[[:space:]]addr:/ /' -ne "s|.*inet${_n}[[:space:]]\{1,\}\([^[:space:]/]*\).*|\1|p")" || return;
    if [[ ! -n $_n ]]; then
        _comp_compgen -U addrs set "${addrs[@]}";
    else
        _comp_compgen -U addrs ltrim_colon "${addrs[@]}";
    fi
}
_comp_compgen_kernel_modules ()
{
    local _modpath=/lib/modules/$1;
    _comp_compgen_split -- "$(command ls -RL "$_modpath" 2> /dev/null | command sed -ne 's/^\(.*\)\.k\{0,1\}o\(\.[gx]z\)\{0,1\}$/\1/p' -e 's/^\(.*\)\.ko\.zst$/\1/p')"
}
_comp_compgen_kernel_versions ()
{
    _comp_compgen_split -- "$(command ls /lib/modules)"
}
_comp_compgen_known_hosts ()
{
    local known_hosts;
    _comp_compgen_known_hosts__impl "$@" || return "$?";
    _comp_compgen -U known_hosts set "${known_hosts[@]}"
}
_comp_compgen_known_hosts__impl ()
{
    known_hosts=();
    local configfile="" flag prefix="";
    local cur suffix="" aliases="" i host ipv4="" ipv6="";
    local -a kh tmpkh=() khd=() config=();
    local OPTIND=1;
    while getopts "ac46F:p:" flag "$@"; do
        case $flag in
            a)
                aliases=set
            ;;
            c)
                suffix=':'
            ;;
            F)
                if [[ ! -n $OPTARG ]]; then
                    echo "bash_completion: $FUNCNAME: -F: an empty filename is specified" 1>&2;
                    return 2;
                fi;
                configfile=$OPTARG
            ;;
            p)
                prefix=$OPTARG
            ;;
            4)
                ipv4=set
            ;;
            6)
                ipv6=set
            ;;
            *)
                echo "bash_completion: $FUNCNAME: usage error" 1>&2;
                return 2
            ;;
        esac;
    done;
    if (($# < OPTIND)); then
        echo "bash_completion: $FUNCNAME: missing mandatory argument CWORD" 1>&2;
        return 2;
    fi;
    cur=${!OPTIND};
    ((OPTIND += 1));
    if (($# >= OPTIND)); then
        echo "bash_completion: $FUNCNAME($*): unprocessed arguments:" "$(while (($# >= OPTIND)); do
    printf '%s ' ${!OPTIND}
shift;
done)" 1>&2;
        return 2;
    fi;
    [[ $cur == *@* ]] && prefix=$prefix${cur%@*}@ && cur=${cur#*@};
    kh=();
    if [[ -n $configfile ]]; then
        [[ -r $configfile && ! -d $configfile ]] && config+=("$configfile");
    else
        for i in /etc/ssh/ssh_config ~/.ssh/config ~/.ssh2/config;
        do
            [[ -r $i && ! -d $i ]] && config+=("$i");
        done;
    fi;
    if ((${#config[@]} > 0)); then
        for i in "${config[@]}";
        do
            _comp__included_ssh_config_files "$i";
        done;
    fi;
    if ((${#config[@]} > 0)); then
        if _comp_split -l tmpkh "$(_comp_awk 'sub("^[ \t]*([Gg][Ll][Oo][Bb][Aa][Ll]|[Uu][Ss][Ee][Rr])[Kk][Nn][Oo][Ww][Nn][Hh][Oo][Ss][Tt][Ss][Ff][Ii][Ll][Ee][ \t=]+", "") { print $0 }' "${config[@]}" | sort -u)"; then
            local tmpkh2 j REPLY;
            for i in "${tmpkh[@]}";
            do
                while [[ $i =~ ^([^\"]*)\"([^\"]*)\"(.*)$ ]]; do
                    i=${BASH_REMATCH[1]}${BASH_REMATCH[3]};
                    _comp_expand_tilde "${BASH_REMATCH[2]}";
                    [[ -r $REPLY ]] && kh+=("$REPLY");
                done;
                _comp_split tmpkh2 "$i" || continue;
                for j in "${tmpkh2[@]}";
                do
                    _comp_expand_tilde "$j";
                    [[ -r $REPLY ]] && kh+=("$REPLY");
                done;
            done;
        fi;
    fi;
    if [[ ! -n $configfile ]]; then
        for i in /etc/ssh/ssh_known_hosts /etc/ssh/ssh_known_hosts2 /etc/known_hosts /etc/known_hosts2 ~/.ssh/known_hosts ~/.ssh/known_hosts2;
        do
            [[ -r $i && ! -d $i ]] && kh+=("$i");
        done;
        for i in /etc/ssh2/knownhosts ~/.ssh2/hostkeys;
        do
            [[ -d $i ]] || continue;
            _comp_expand_glob tmpkh '"$i"/*.pub' && khd+=("${tmpkh[@]}");
        done;
    fi;
    if ((${#kh[@]} + ${#khd[@]} > 0)); then
        if ((${#kh[@]} > 0)); then
            for i in "${kh[@]}";
            do
                while read -ra tmpkh; do
                    ((${#tmpkh[@]} == 0)) && continue;
                    [[ ${tmpkh[0]} == [\|\#]* ]] && continue;
                    local host_list=${tmpkh[0]};
                    [[ ${tmpkh[0]} == @* ]] && host_list=${tmpkh[1]-};
                    local -a hosts;
                    if _comp_split -F , hosts "$host_list"; then
                        for host in "${hosts[@]}";
                        do
                            [[ $host == *[*?]* ]] && continue;
                            host=${host#[};
                            host=${host%]?(:+([0-9]))};
                            [[ -n $host ]] && known_hosts+=("$host");
                        done;
                    fi;
                done < "$i";
            done;
        fi;
        if ((${#khd[@]} > 0)); then
            for i in "${khd[@]}";
            do
                if [[ $i == *key_22_*.pub && -r $i ]]; then
                    host=${i/#*key_22_/};
                    host=${host/%.pub/};
                    [[ -n $host ]] && known_hosts+=("$host");
                fi;
            done;
        fi;
        ((${#known_hosts[@]})) && _comp_compgen -v known_hosts -- -W '"${known_hosts[@]}"' -P "$prefix" -S "$suffix";
    fi;
    if [[ ${#config[@]} -gt 0 && -n $aliases ]]; then
        local -a hosts;
        if _comp_split hosts "$(command sed -ne 's/^[[:blank:]]*[Hh][Oo][Ss][Tt][[:blank:]=]\{1,\}\(.*\)$/\1/p' "${config[@]}")"; then
            _comp_compgen -av known_hosts -- -P "$prefix" -S "$suffix" -W '"${hosts[@]%%[*?%]*}"' -X '@(\!*|)';
        fi;
    fi;
    if [[ -n ${BASH_COMPLETION_KNOWN_HOSTS_WITH_AVAHI-} ]] && type avahi-browse &> /dev/null; then
        local generated=$(avahi-browse -cprak 2> /dev/null | _comp_awk -F ';' '/^=/ && $5 ~ /^_(ssh|workstation)\._tcp$/ { print $7 }' | sort -u);
        _comp_compgen -av known_hosts -- -P "$prefix" -S "$suffix" -W '$generated';
    fi;
    if type ruptime &> /dev/null; then
        local generated=$(ruptime 2> /dev/null | _comp_awk '!/^ruptime:/ { print $1 }');
        _comp_compgen -av known_hosts -- -W '$generated';
    fi;
    if [[ -n ${BASH_COMPLETION_KNOWN_HOSTS_WITH_HOSTFILE-set} ]]; then
        _comp_compgen -av known_hosts -- -A hostname -P "$prefix" -S "$suffix";
    fi;
    ((${#known_hosts[@]})) || return 1;
    if [[ -n $ipv4 ]]; then
        known_hosts=("${known_hosts[@]/*:*$suffix/}");
    fi;
    if [[ -n $ipv6 ]]; then
        known_hosts=("${known_hosts[@]/+([0-9]).+([0-9]).+([0-9]).+([0-9])$suffix/}");
    fi;
    if [[ -n $ipv4 || -n $ipv6 ]]; then
        for i in "${!known_hosts[@]}";
        do
            [[ -n ${known_hosts[i]} ]] || unset -v 'known_hosts[i]';
        done;
    fi;
    ((${#known_hosts[@]})) || return 1;
    _comp_compgen -v known_hosts -c "$prefix$cur" ltrim_colon "${known_hosts[@]}"
}
_comp_compgen_ltrim_colon ()
{
    (($#)) || return 0;
    local -a _tmp;
    _tmp=("$@");
    if [[ $cur == *:* && $COMP_WORDBREAKS == *:* ]]; then
        local _colon_word=${cur%"${cur##*:}"};
        _tmp=("${_tmp[@]#"$_colon_word"}");
    fi;
    _comp_compgen_set "${_tmp[@]}"
}
_comp_compgen_mac_addresses ()
{
    local _re='\([A-Fa-f0-9]\{2\}:\)\{5\}[A-Fa-f0-9]\{2\}';
    local PATH="$PATH:/sbin:/usr/sbin";
    local -a addresses;
    _comp_compgen -v addresses split -- "$({ ip -c=never link show || ip link show || LC_ALL=C ifconfig -a; } 2> /dev/null | command sed -ne "s/.*[[:space:]]HWaddr[[:space:]]\{1,\}\($_re\)[[:space:]].*/\1/p" -ne "s/.*[[:space:]]HWaddr[[:space:]]\{1,\}\($_re\)[[:space:]]*$/\1/p" -ne "s|.*[[:space:]]\(link/\)\{0,1\}ether[[:space:]]\{1,\}\($_re\)[[:space:]].*|\2|p" -ne "s|.*[[:space:]]\(link/\)\{0,1\}ether[[:space:]]\{1,\}\($_re\)[[:space:]]*$|\2|p")";
    _comp_compgen -av addresses split -- "$({ arp -an || ip -c=never neigh show || ip neigh show; } 2> /dev/null | command sed -ne "s/.*[[:space:]]\($_re\)[[:space:]].*/\1/p" -ne "s/.*[[:space:]]\($_re\)[[:space:]]*$/\1/p")";
    _comp_compgen -av addresses split -- "$(command sed -ne "s/^[[:space:]]*\($_re\)[[:space:]].*/\1/p" /etc/ethers 2> /dev/null)";
    _comp_compgen -U addresses ltrim_colon "${addresses[@]}"
}
_comp_compgen_pci_ids ()
{
    _comp_compgen_split -- "$(PATH="$PATH:/sbin" lspci -n | _comp_awk '{print $3}')"
}
_comp_compgen_pgids ()
{
    _comp_compgen_split -- "$(command ps ax -o pgid=)"
}
_comp_compgen_pids ()
{
    _comp_compgen_split -- "$(command ps ax -o pid=)"
}
_comp_compgen_pnames ()
{
    local -a procs=();
    if [[ ${1-} == -s ]]; then
        _comp_split procs "$(command ps ax -o comm | command sed -e 1d)";
    else
        local -a psout;
        _comp_split -l psout "$({ command ps ax -o command= || command ps ax -o comm=; } 2> /dev/null)";
        local line i=-1;
        for line in "${psout[@]}";
        do
            if ((i == -1)); then
                if [[ $line =~ ^(.*[[:space:]])COMMAND([[:space:]]|$) ]]; then
                    i=${#BASH_REMATCH[1]};
                else
                    break;
                fi;
            else
                line=${line:i};
                line=${line%% *};
                [[ -n $line ]] && procs+=("$line");
            fi;
        done;
        if ((i == -1)); then
            for line in "${psout[@]}";
            do
                if [[ $line =~ ^[[(](.+)[])]$ ]]; then
                    procs+=("${BASH_REMATCH[1]}");
                else
                    line=${line%% *};
                    line=${line##@(*/|-)};
                    [[ -n $line ]] && procs+=("$line");
                fi;
            done;
        fi;                                                                                                               fi;
    ((${#procs[@]})) && _comp_compgen -U procs -- -X "<defunct>" -W '"${procs[@]}"'
}
_comp_compgen_selinux_users ()
{
    _comp_compgen_split -- "$(semanage user -nl 2> /dev/null | _comp_awk '{ print $1 }')"
}
_comp_compgen_services ()
{
    local sysvdirs;
    _comp_sysvdirs || return 1;
    local services;
    _comp_expand_glob services '${sysvdirs[0]}/!($_comp_backup_glob|functions|README)';
    local _generated=$({ systemctl list-units --full --all || systemctl list-unit-files; } 2> /dev/null | _comp_awk '$1 ~ /\.service$/ { sub("\\.service$", "", $1); print $1 }');
    _comp_split -la services "$_gen
done

