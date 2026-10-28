#!/bin/bash
# ---------- SENATEVIL BANNER ----------
show_senatevil_banner() {
    printf '\033[1;31m'
    cat <<'SENATEVIL_BANNER'

  ███████╗███████╗███╗   ██╗ █████╗ ████████╗███████╗██╗   ██╗██╗██╗
  ██╔════╝██╔════╝████╗  ██║██╔══██╗╚══██╔══╝██╔════╝██║   ██║██║██║
  ███████╗█████╗  ██╔██╗ ██║███████║   ██║   █████╗  ██║   ██║██║██║
  ╚════██║██╔══╝  ██║╚██╗██║██╔══██║   ██║   ██╔══╝  ╚██╗ ██╔╝██║██║
  ███████║███████╗██║ ╚████║██║  ██║   ██║   ███████╗ ╚████╔╝ ██║██████
  ╚══════╝╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝   ╚═╝   ╚══════╝  ╚═══╝  ╚═╝╚═══╝╝

                 [ CYBERSEC TOOLKIT v2.0 ]
            Auditoría local y reconocimiento autorizado
SENATEVIL_BANNER
    printf '\033[0m\n'
}
# ---------------------------------------------
# CYBERSEC TOOLKIT v2.0
# Toolkit interactivo para auditoría local y reconocimiento autorizado
# Uso: ./cibersec_toolkit.sh

set -uo pipefail
umask 077

# ---------- COLORES ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ---------- DIRECTORIOS Y SESIÓN ----------
BASE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
RUN_ID="$(date '+%Y%m%d_%H%M%S')_$$"
OUTPUT_DIR="$BASE_DIR/cybersec_results/$RUN_ID"
REPORT_DIR="$BASE_DIR/cybersec_results/reports"
LOG_FILE=""

mkdir -p -- "$OUTPUT_DIR" "$REPORT_DIR" 2>/dev/null || {
    echo -e "${RED}[ERROR]${NC} No se pudieron crear los directorios de resultados." >&2
    exit 1
}

LOG_FILE="$OUTPUT_DIR/session.log"
touch "$LOG_FILE" 2>/dev/null || exit 1

# ---------- FUNCIONES DE LOGGING ----------
log_info() {
    echo -e "${CYAN}[INFO]${NC} $*"
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

log_ok() {
    echo -e "${GREEN}[OK]${NC} $*"
    echo "[OK] $(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
    echo "[WARN] $(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') $*" >> "$LOG_FILE"
}

pausar() {
    echo -e "\n${CYAN}Presiona ENTER para volver al menú...${NC}"
    if [ -t 0 ]; then
        read -r _
    elif [ -r /dev/tty ]; then
        read -r _ </dev/tty
    else
        sleep 2
    fi
}

timestamp() {
    date '+%Y-%m-%d %H:%M:%S%z'
}

require_cmd() {
    local cmd missing=0
    for cmd in "$@"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            log_ok "Disponible: $cmd"
        else
            log_warn "No instalado: $cmd"
            missing=1
        fi
    done
    return "$missing"
}

valid_domain() {
    local domain="${1%.}"
    local label
    local -a labels
    [[ ${#domain} -le 253 && "$domain" == *.* ]] || return 1
    [[ "$domain" != *..* ]] || return 1
    IFS='.' read -r -a labels <<< "$domain"
    for label in "${labels[@]}"; do
        [[ ${#label} -ge 1 && ${#label} -le 63 ]] || return 1
        [[ "$label" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]] || return 1
    done
    return 0
}

# ---------- CABECERA ----------
show_header() {
    clear 2>/dev/null || true
    show_senatevil_banner
    echo -e "${CYAN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              CYBERSEC TOOLKIT v2.0               ║${NC}"
    echo -e "${CYAN}║         Auditoría local + Reconocimiento         ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════╝${NC}"
    echo -e "${GREEN}Usuario:${NC} $(id -un) | ${GREEN}Host:${NC} $(hostname)"
    echo -e "${GREEN}Sesión:${NC} $RUN_ID"
    echo -e "${GREEN}Evidencias:${NC} $OUTPUT_DIR"
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}\n"
}

# ---------- 1. INFORMACIÓN RÁPIDA DEL SISTEMA ----------
info_sistema() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           INFORMACIÓN DEL SISTEMA            ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${GREEN}[*] Hostname:${NC} $(hostname)"
    echo -e "${GREEN}[*] Usuario actual:${NC} $USER"
    echo -e "${GREEN}[*] Fecha:${NC} $(date)"
    echo -e "${GREEN}[*] Kernel:${NC} $(uname -r)"
    echo -e "${GREEN}[*] Sistema:${NC} $(uname -s)"
    echo -e "${GREEN}[*] Arquitectura:${NC} $(uname -m)"
    echo -e "${GREEN}[*] IPs locales:${NC}"
    ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' || hostname -I
    echo -e "${GREEN}[*] Uptime:${NC} $(uptime -p 2>/dev/null || uptime)"
    pausar
}

# ---------- 2. AUDITORÍA AVANZADA DEL SISTEMA ----------
auditoria_sistema_avanzada() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║        AUDITORÍA AVANZADA DEL SISTEMA         ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    local out="$OUTPUT_DIR/system_audit.txt"
    log_info "Iniciando auditoría avanzada del sistema..."
    {
        echo "=== AUDITORÍA AVANZADA DEL SISTEMA ==="
        echo "Fecha: $(timestamp)"
        echo "Host: $(hostname)"
        echo "Usuario: $(id -un)"
        echo ""

        echo "--- Sistema Operativo ---"
        [[ -r /etc/os-release ]] && grep -E '^(PRETTY_NAME|VERSION_ID|ID)=' /etc/os-release
        uname -a
        echo ""

        echo "--- Usuario actual y grupos ---"
        id
        echo ""

        echo "--- Usuarios con shell interactiva ---"
        awk -F: '$7 ~ /(bash|zsh|fish|ksh|sh)$/ {printf "[+] %-18s Shell: %s\n", $1, $7}' /etc/passwd
        echo ""

        echo "--- Servicios/puertos en escucha ---"
        if command -v ss >/dev/null 2>&1; then ss -lntup 2>&1; elif command -v netstat >/dev/null 2>&1; then netstat -tulnp 2>&1; else echo "[!] No se encontró ss/netstat"; fi
        echo ""

        echo "--- Permisos de archivos sensibles ---"
        for f in /etc/passwd /etc/shadow /etc/hosts /etc/ssh/sshd_config /etc/sudoers; do
            [[ -e "$f" ]] && stat -c '[*] %A (%a) %U:%G %n' "$f" 2>&1
        done
        echo ""

        echo "--- Archivos SUID en rutas críticas ---"
        for dir in /usr/bin /usr/sbin /usr/local/bin /bin /sbin; do
            [[ -d "$dir" ]] && find "$dir" -xdev -type f -perm /4000 -print 2>/dev/null
        done
        echo ""

        echo "--- Recursos del sistema ---"
        echo "[*] Disco:" && df -h 2>&1
        echo -e "\n[*] Memoria:" && (free -h 2>&1 || vmstat -s 2>&1)
        echo -e "\n[*] Top CPU:" && ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu 2>&1 | head -n 16
    } > "$out" 2>&1
    log_ok "Auditoría guardada: $out"
    cat "$out"
    if [ -t 0 ] || [ -r /dev/tty ]; then
        pausar
    else
        sleep 3
    fi
}

# ---------- 3. USUARIOS Y SESIONES ----------
usuarios_sesion() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         USUARIOS Y SESIONES ACTIVAS          ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}[+] Usuarios conectados:${NC}"; who
    echo -e "\n${YELLOW}[+] Últimos logins:${NC}"; last -n 8
    echo -e "\n${YELLOW}[+] Usuarios con shell válida:${NC}"
    grep -v '/sbin/nologin\|/usr/sbin/nologin\|/bin/false' /etc/passwd | cut -d: -f1,3,7
    pausar
}

# ---------- 4. ARCHIVOS SUID/SGID ----------
suid_sgid() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           ARCHIVOS SUID / SGID               ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}[!] Buscando archivos con bit SUID...${NC}"
    find /usr/bin /usr/sbin /bin /sbin /usr/local/bin 2>/dev/null -type f -perm /4000
    echo -e "\n${YELLOW}[!] Buscando archivos con bit SGID...${NC}"
    find /usr/bin /usr/sbin /bin /sbin /usr/local/bin 2>/dev/null -type f -perm /2000
    echo -e "\n${RED}[AVISO]${NC} Muchos son legítimos. Investiga aquellos poco comunes."
    pausar
}

# ---------- 5. ANÁLISIS DE LOGS DE AUTENTICACIÓN ----------
analisis_logs_auth() {
    clear
    echo -e "${RED}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║       ANÁLISIS DE LOGS DE AUTENTICACIÓN       ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════╝${NC}"
    local out="$OUTPUT_DIR/auth_log_analysis.txt"
    local tmp="$OUTPUT_DIR/.auth_tmp.tmp"
    local source=""
    log_info "Analizando logs de autenticación..."
    : > "$tmp"
    if [[ -r /var/log/auth.log ]]; then
        source="/var/log/auth.log"
        grep -Ei 'failed password|authentication failure|invalid user|failed publickey|permission denied' "$source" >> "$tmp" 2>/dev/null || true
    elif [[ -r /var/log/secure ]]; then
        source="/var/log/secure"
        grep -Ei 'failed password|authentication failure|invalid user|failed publickey|permission denied' "$source" >> "$tmp" 2>/dev/null || true
    elif command -v journalctl >/dev/null 2>&1; then
        source="systemd journal (sshd/auth)"
        journalctl --no-pager -q -n 3000 -u ssh.service -u sshd 2>/dev/null | grep -Ei 'failed|invalid|denied|failure' >> "$tmp" || true
    else
        log_error "No se encontró fuente de logs de autenticación accesible."
        pausar
        return 1
    fi
    {
        echo "=== ANÁLISIS DE LOGS DE AUTENTICACIÓN ==="
        echo "Fecha: $(timestamp)"
        echo "Fuente: $source"
        echo "Eventos sospechosos encontrados: $(wc -l < "$tmp")"
        echo ""
        echo "--- Últimos 80 eventos ---"
        tail -n 80 "$tmp"
        echo ""
        echo "--- IPs con mayor frecuencia ---"
        grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "$tmp" | grep -v '127.0.0.1' | sort | uniq -c | sort -nr | head -n 15
        echo ""
        echo "--- Usuarios objetivo ---"
        grep -Eo 'invalid user [a-zA-Z0-9_.-]+' "$tmp" | awk '{print $3}' | sort | uniq -c | sort -nr | head -n 10
    } > "$out" 2>&1
    rm -f -- "$tmp"
    log_ok "Análisis guardado: $out"
    cat "$out"
    pausar
}

# ---------- 6. INVENTARIO SHA256 ----------
inventario_sha256() {
    local target out count=0 errors=0 file hash
    require_cmd find sha256sum || { pausar; return 1; }
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║           INVENTARIO SHA256                   ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Ruta del directorio a analizar:${NC}"
    read -r target
    [[ -z "$target" || ! -d "$target" || ! -r "$target" ]] && { log_error "Directorio inválido o no legible."; pausar; return 1; }
    target="$(cd -- "$target" && pwd -P)"
    out="$OUTPUT_DIR/hashes_$(basename "$target").sha256"
    log_info "Calculando hashes SHA256 de: $target"
    : > "$out"
    while IFS= read -r -d '' file; do
        if hash="$(sha256sum < "$file" 2>/dev/null)"; then
            printf '%s  %s\n' "${hash%% *}" "$file" >> "$out"
            ((count++))
        else
            log_warn "No se pudo leer: $file"
            ((errors++))
        fi
    done < <(find "$target" -type f -readable -print0 2>/dev/null)
    echo -e "\n${GREEN}[+] Archivos procesados:${NC} $count"
    echo -e "${YELLOW}[!] Errores de lectura:${NC} $errors"
    log_ok "Inventario guardado: $out"
    pausar
}

# ---------- 7. RECONOCIMIENTO DNS AUTORIZADO ----------
recon_dns() {
    local domain out type
    local -a types=(A AAAA MX NS TXT CNAME SOA)
    require_cmd dig || { log_error "dig no está instalado."; pausar; return 1; }
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║        RECONOCIMIENTO DNS AUTORIZADO          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Dominio (solo con autorización):${NC}"
    read -r domain </dev/tty
    if [ -z "$domain" ]; then
        log_error "No se ingresó ningún dominio."
        pausar
        return 1
    fi
    domain="${domain%.}"
    valid_domain "$domain" || { log_error "Dominio no válido. Ej: example.com"; pausar; return 1; }
    out="$OUTPUT_DIR/dns_$(echo "$domain" | tr '.' '_').txt"
    log_info "Consultando registros DNS de: $domain"
    {
        echo "╔══════════════════════════════════════════════════╗"
        echo "║           RECONOCIMIENTO DNS AUTORIZADO           ║"
        echo "╚══════════════════════════════════════════════════╝"
        echo ""
        echo "Fecha: $(timestamp)"
        echo "Dominio: $domain"
        echo "Servidor DNS por defecto: $(grep '^nameserver' /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}')"
        echo ""
        echo "══════════════════════════════════════════════════"
    } > "$out"
    for type in "${types[@]}"; do
        echo -e "\n${YELLOW}[+] Consultando registros $type...${NC}"
        {
            echo ""
            echo "--- REGISTROS $type ---"
            if dig +time=3 +tries=2 +short "$domain" "$type" >/dev/null 2>&1; then
                dig +time=3 +tries=2 "$domain" "$type" 2>&1 | grep -v '^;' | grep -v '^$'
            else
                echo "[SIN RESPUESTA O ERROR]"
            fi
            echo ""
        } >> "$out"
    done
    log_ok "Resultados DNS guardados: $out"
    echo -e "\n${GREEN}[+] Mostrando resultados:${NC}"
    cat "$out"
    pausar
}

# ---------- 8. PUERTOS ABIERTOS Y CONEXIONES ----------
conexiones_red() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         PUERTOS ABIERTOS Y CONEXIONES        ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    if command -v ss >/dev/null 2>&1; then
        echo -e "${GREEN}[+] Escuchando (TCP/UDP):${NC}"; ss -tulnp 2>/dev/null | head -30
        echo -e "\n${GREEN}[+] Conexiones ESTABLISHED:${NC} $(ss -tan 2>/dev/null | grep -c ESTAB)"
    elif command -v netstat >/dev/null 2>&1; then
        echo -e "${GREEN}[+] Escuchando (TCP/UDP):${NC}"; netstat -tulnp 2>/dev/null | head -30
    else
        log_error "Ni ss ni netstat disponibles"
    fi
    pausar
}

# ---------- 9. PROCESOS ----------
procesos_sospechosos() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║           PROCESOS EN EJECUCIÓN              ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}[+] Top 15 por CPU:${NC}"; ps aux --sort=-%cpu | head -16
    echo -e "\n${YELLOW}[+] Procesos ejecutados por root:${NC} $(ps -U root -u root 2>/dev/null | wc -l)"
    pausar
}

# ---------- 10. ESCÁNER AVANZADO DE PUERTOS ----------
escaner_puertos() {
    clear
    echo -e "${BLUE}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║          ESCÁNER AVANZADO DE PUERTOS          ║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}IP o dominio a escanear:${NC}"; read -r objetivo
    [[ -z "$objetivo" ]] && { log_error "Sin objetivo."; pausar; return; }
    if [[ ! "$objetivo" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_info "Resolviendo dominio..."
        objetivo_ip="$(getent hosts "$objetivo" 2>/dev/null | awk '{print $1}' | head -1)"
        [[ -z "$objetivo_ip" ]] && { log_error "No se pudo resolver."; pausar; return; }
        echo -e "${GREEN}[+] $objetivo -> $objetivo_ip${NC}"
    else
        objetivo_ip="$objetivo"
    fi
    echo -e "\n${CYAN}Modo:${NC}\n[1] Rápido (críticos)\n[2] Intermedio (1-1024)\n[3] Personalizado\n[0] Volver\nOpción: "; read -r modo
    case "$modo" in
        1)
            local -a p=(21 22 23 25 53 80 110 111 135 139 143 443 445 993 995 1433 1521 2049 3306 3389 5432 5900 6379 8000 8080 8443 9000 9090 27017 11211)
            log_info "Escaneando puertos críticos..."
            for puerto in "${p[@]}"; do (timeout 2 bash -c "echo > /dev/tcp/$objetivo_ip/$puerto" 2>/dev/null && echo -e "${GREEN}[ABIERTO]${NC} $objetivo_ip:$puerto") & done; wait
            ;;
        2)
            log_info "Escaneando 1-1024 en paralelo..."
            for puerto in {1..1024}; do (timeout 1 bash -c "echo > /dev/tcp/$objetivo_ip/$puerto" 2>/dev/null && echo -e "${GREEN}[ABIERTO]${NC} $objetivo_ip:$puerto") & ((puerto % 50 == 0)) && wait; done; wait
            ;;
        3)
            echo -e "${CYAN}Inicio:${NC}"; read -r ini; echo -e "${CYAN}Fin:${NC}"; read -r fin
            [[ ! "$ini" =~ ^[0-9]+$ || ! "$fin" =~ ^[0-9]+$ || $ini -gt $fin ]] && { log_error "Rango inválido."; pausar; return; }
            log_info "Escaneando $objetivo_ip:$ini-$fin"
            for puerto in $(seq "$ini" "$fin"); do (timeout 1 bash -c "echo > /dev/tcp/$objetivo_ip/$puerto" 2>/dev/null && echo -e "${GREEN}[ABIERTO]${NC} $objetivo_ip:$puerto") & (( (puerto-ini)%40==0 )) && wait; done; wait
            ;;
        0) return ;;
        *) log_warn "Opción inválida."; pausar; return ;;
    esac
    echo -e "\n${GREEN}[+] Escaneo finalizado.${NC}"; pausar
}

# ---------- 11. VERIFICAR DEPENDENCIAS ----------
verificar_dependencias() {
    clear
    echo -e "${MAGENTA}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║            VERIFICAR DEPENDENCIAS             ║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════╝${NC}"
    local -a req=(bash awk grep sed find sha256sum ps ss ip hostname id stat date)
    local -a opt=(dig journalctl less getent timeout)
    echo -e "${YELLOW}[+] Requeridas:${NC}"; for c in "${req[@]}"; do command -v "$c" >/dev/null 2>&1 && echo -e "  ${GREEN}[OK]${NC} $c" || echo -e "  ${RED}[FALTA]${NC} $c"; done
    echo -e "\n${YELLOW}[+] Opcionales (mejoran funcionalidad):${NC}"; for c in "${opt[@]}"; do command -v "$c" >/dev/null 2>&1 && echo -e "  ${GREEN}[OK]${NC} $c" || echo -e "  ${CYAN}[INFO]${NC} $c no disponible"; done
    pausar
}

# ---------- 12. VER LOG DE SESIÓN ----------
ver_log_sesion() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║              LOG DE ACTIVIDAD                 ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    [[ -s "$LOG_FILE" ]] && (cat "$LOG_FILE") || log_warn "Log vacío"
    pausar
}

# ---------- 13. GENERAR INFORME ----------
generar_informe() {
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            GENERAR INFORME DE SESIÓN          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
    local report="$REPORT_DIR/INFORME_CYBERSEC_$(date '+%Y%m%d_%H%M%S').txt"
    local report_html="$REPORT_DIR/INFORME_CYBERSEC_$(date '+%Y%m%d_%H%M%S').html"
    log_info "Generando informe profesional..."
    {
        echo "╔══════════════════════════════════════════════════════════════════╗"
        echo "║                CYBERSEC TOOLKIT v2.0 - REPORTE TÉCNICO            ║"
        echo "╚══════════════════════════════════════════════════════════════════╝"
        echo ""
        echo "INFORMACIÓN GENERAL"
        echo "──────────────────────────────────────────────────────────────────"
        echo "  Fecha/Hora      : $(timestamp)"
        echo "  Equipo           : $(hostname)"
        echo "  Usuario          : $(id -un) [UID:$(id -u)]"
        echo "  Sistema          : $(uname -srm)"
        echo "  Sesión ID        : $RUN_ID"
        echo "  Ruta de evidencias: $OUTPUT_DIR"
        echo ""
        echo "══════════════════════════════════════════════════════════════════"
        echo ""
        echo "1. REGISTRO DE ACTIVIDAD"
        echo "──────────────────────────────────────────────────────────────────"
        if [[ -s "$LOG_FILE" ]]; then
            cat "$LOG_FILE"
        else
            echo "  [SIN REGISTROS]"
        fi
        echo ""
        echo "══════════════════════════════════════════════════════════════════"
        echo ""
        echo "2. ARCHIVOS GENERADOS EN ESTA SESIÓN"
        echo "──────────────────────────────────────────────────────────────────"
        local cnt=0
        while IFS= read -r -d '' f; do
            echo "  [ARCHIVO] $(basename "$f") | Tamaño: $(stat -c%s "$f") bytes"
            ((cnt++))
        done < <(find "$OUTPUT_DIR" -maxdepth 1 -type f ! -name 'session.log' -print0 2>/dev/null)
        (( cnt == 0 )) && echo "  [SIN ARCHIVOS]"
        echo ""
        echo "══════════════════════════════════════════════════════════════════"
        echo ""
        echo "3. INTEGRIDAD DE EVIDENCIAS - FIRMA SHA256"
        echo "──────────────────────────────────────────────────────────────────"
        local hasfiles=0
        while IFS= read -r -d '' file; do
            sha256sum "$file"
            hasfiles=1
        done < <(find "$OUTPUT_DIR" -maxdepth 1 -type f ! -name 'session.log' -print0 2>/dev/null)
        (( hasfiles == 0 )) && echo "  [SIN ARCHIVOS PARA VERIFICAR]"
        echo ""
        echo "══════════════════════════════════════════════════════════════════"
        echo ""
        echo "ELABORADO POR: CYBERSEC TOOLKIT v2.0 | USO ÚNICAMENTE AUTORIZADO"
        echo "╚══════════════════════════════════════════════════════════════════╝"
    } > "$report" 2>&1

    {
        cat <<EOF
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Reporte Técnico - Cybersec Toolkit v2.0</title>
<style>
body{background:#0f1026;color:#e4e6eb;font-family:Consolas,monospace;margin:0;padding:40px}
header{border-left:4px solid #4f9deb;padding-left:20px;margin-bottom:40px}
header h1{margin:0;color:#4f9deb}
header p{margin:5px 0;color:#9aa0a6}
section{margin-bottom:40px}
h2{color:#7ee787;border-bottom:1px solid #30363d;padding-bottom:10px}
table{width:100%;border-collapse:collapse;background:#161b22}
th,td{padding:12px;border:1px solid #30363d;text-align:left}
th{background:#1f6feb;color:#fff}
tr:nth-child(even){background:#0d1117}
footer{text-align:center;color:#6e7681;margin-top:60px}
.code{background:#0d1117;padding:15px;border:1px solid #30363d;overflow-x:auto;white-space:pre}
</style>
</head>
<body>
<header>
<h1>REPORTE TÉCNICO - CYBERSEC TOOLKIT v2.0</h1>
<p>Auditoría Local y Reconocimiento Autorizado</p>
<p>Generado: $(timestamp) | Host: $(hostname) | Usuario: $(id -un)</p>
</header>
<section>
<h2>1. Información General</h2>
<table>
<tr><th>Campo</th><th>Valor</th></tr>
<tr><td>Fecha/Hora</td><td>$(timestamp)</td></tr>
<tr><td>Hostname</td><td>$(hostname)</td></tr>
<tr><td>Usuario</td><td>$(id -un) (UID: $(id -u))</td></tr>
<tr><td>Sistema</td><td>$(uname -srm)</td></tr>
<tr><td>Sesión ID</td><td>$RUN_ID</td></tr>
<tr><td>Evidencias</td><td>$OUTPUT_DIR</td></tr>
</table>
</section>
<section>
<h2>2. Registro de Actividad</h2>
<div class="code">$(cat "$LOG_FILE" 2>/dev/null | sed 's/&/\&amp;/g;s/</\&lt;/g;s/>/\&gt;/g')</div>
</section>
<section>
<h2>3. Archivos Generados</h2>
<table>
<tr><th>Archivo</th><th>Tamaño (bytes)</th></tr>
EOF
        while IFS= read -r -d '' f; do
            echo "<tr><td>$(basename "$f")</td><td>$(stat -c%s "$f")</td></tr>"
        done < <(find "$OUTPUT_DIR" -maxdepth 1 -type f ! -name 'session.log' -print0 2>/dev/null)
        echo "</table>"
        echo "</section>"
        echo "<section><h2>4. Integridad SHA256</h2><div class=\"code\">"
        while IFS= read -r -d '' file; do
            sha256sum "$file"
        done < <(find "$OUTPUT_DIR" -maxdepth 1 -type f ! -name 'session.log' -print0 2>/dev/null)
        echo "</div></section>"
        echo "<footer><p>Cybersec Toolkit v2.0 | Uso Únicamente Autorizado</p></footer></body></html>"
    } > "$report_html" 2>&1

    log_ok "Informe TXT generado: $report"
    log_ok "Informe HTML generado: $report_html"
    echo -e "\n${GREEN}[+] Archivos creados:${NC}"
    echo -e "  ${CYAN}•${NC} $report"
    echo -e "  ${CYAN}•${NC} $report_html"
    echo -e "\n${YELLOW}[+] Abriendo informe TXT...${NC}"
    cat "$report"
    pausar
}

# ---------- 14. GESTOR DE PERMISOS CHMOD ----------
gestor_permisos() {
    clear
    echo -e "${YELLOW}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║           GESTOR DE PERMISOS (CHMOD)          ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Ruta del archivo o directorio:${NC}"
    read -r archivo
    if [ -z "$archivo" ]; then
        log_error "No se ingresó ninguna ruta."
        pausar
        return 1
    fi
    if [ ! -e "$archivo" ]; then
        log_error "El archivo o directorio no existe."
        pausar
        return 1
    fi
    echo -e "\n${GREEN}[*] Archivo seleccionado:${NC} $archivo"
    echo -e "${GREEN}[*] Permisos actuales:${NC} $(stat -c '%A (%a)' "$archivo" 2>/dev/null)"
    echo -e "\n${CYAN}¿Qué deseas hacer?${NC}"
    echo -e "${GREEN}[1]${NC} Agregar permisos"
    echo -e "${RED}[2]${NC} Quitar permisos"
    echo -e "${YELLOW}[0]${NC} Volver"
    echo -e "${CYAN}Opción:${NC} "
    read -r accion
    case "$accion" in
        1) accion_modo="+" ;;
        2) accion_modo="-" ;;
        0) return ;;
        *) log_warn "Opción inválida."; pausar; return ;;
    esac
    echo -e "\n${CYAN}Selecciona el permiso a modificar:${NC}"
    echo -e "${GREEN}[1]${NC} Lectura (r)"
    echo -e "${GREEN}[2]${NC} Escritura (w)"
    echo -e "${GREEN}[3]${NC} Ejecución (x)"
    echo -e "${YELLOW}[4]${NC} Lectura + Escritura (rw)"
    echo -e "${YELLOW}[5]${NC} Lectura + Ejecución (rx)"
    echo -e "${YELLOW}[6]${NC} Escritura + Ejecución (wx)"
    echo -e "${CYAN}[7]${NC} Lectura + Escritura + Ejecución (rwx)"
    echo -e "${YELLOW}[0]${NC} Volver"
    echo -e "${CYAN}Opción:${NC} "
    read -r perm_op
    case "$perm_op" in
        1) modo_perm="r" ;;
        2) modo_perm="w" ;;
        3) modo_perm="x" ;;
        4) modo_perm="rw" ;;
        5) modo_perm="rx" ;;
        6) modo_perm="wx" ;;
        7) modo_perm="rwx" ;;
        0) return ;;
        *) log_warn "Opción inválida."; pausar; return ;;
    esac
    echo -e "\n${CYAN}¿A quién aplicar?${NC}"
    echo -e "${GREEN}[1]${NC} Usuario (u)"
    echo -e "${GREEN}[2]${NC} Grupo (g)"
    echo -e "${GREEN}[3]${NC} Otros (o)"
    echo -e "${CYAN}[4]${NC} Todos (a)"
    echo -e "${YELLOW}[0]${NC} Volver"
    echo -e "${CYAN}Opción:${NC} "
    read -r who_op
    case "$who_op" in
        1) who_perm="u" ;;
        2) who_perm="g" ;;
        3) who_perm="o" ;;
        4) who_perm="a" ;;
        0) return ;;
        *) log_warn "Opción inválida."; pausar; return ;;
    esac
    echo -e "\n${YELLOW}[!] Se aplicará: chmod $who_perm$accion_modo$modo_perm $archivo${NC}"
    echo -e "${CYAN}¿Confirmar? [s/N]:${NC} "
    read -r confirm
    if [[ "$confirm" =~ ^[sS]$ ]]; then
        if chmod "$who_perm$accion_modo$modo_perm" "$archivo" 2>/dev/null; then
            log_ok "Permisos actualizados correctamente."
            echo -e "${GREEN}[*] Nuevos permisos:${NC} $(stat -c '%A (%a)' "$archivo" 2>/dev/null)"
        else
            log_error "No se pudieron modificar los permisos (¿Permisos insuficientes?)."
        fi
    else
        log_warn "Operación cancelada."
    fi
    pausar
}

# ---------- 15. AUDITORÍA COMPLETA ----------
auditoria_completa() {
    clear
    echo -e "${RED}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║             AUDITORÍA LOCAL COMPLETA          ║${NC}"
    echo -e "${RED}╚══════════════════════════════════════════════╝${NC}"
    log_info "Iniciando auditoría local completa..."
    auditoria_sistema_avanzada
    analisis_logs_auth
    conexiones_red
    procesos_sospechosos
    suid_sgid
    verificar_dependencias
    generar_informe
    log_ok "Auditoría completa finalizada. Revisa $OUTPUT_DIR"
    pausar
}

# ---------- MENÚ PRINCIPAL ----------
while true; do
    show_header
    echo -e "${GREEN}[1]${NC} Info rápida del sistema"
    echo -e "${BLUE}[2]${NC} Auditoría avanzada del sistema"
    echo -e "${CYAN}[3]${NC} Usuarios y sesiones activas"
    echo -e "${YELLOW}[4]${NC} Buscar archivos SUID/SGID"
    echo -e "${RED}[5]${NC} Análisis logs de autenticación"
    echo -e "${MAGENTA}[6]${NC} Inventario SHA256 de directorio"
    echo -e "${CYAN}[7]${NC} Reconocimiento DNS (autorizado)"
    echo -e "${GREEN}[8]${NC} Puertos abiertos y conexiones"
    echo -e "${YELLOW}[9]${NC} Procesos en ejecución"
    echo -e "${BLUE}[10]${NC} Escáner avanzado de puertos"
    echo -e "${MAGENTA}[11]${NC} Verificar dependencias"
    echo -e "${CYAN}[12]${NC} Ver log de actividad"
    echo -e "${GREEN}[13]${NC} Generar informe de sesión"
    echo -e "${YELLOW}[14]${NC} Gestor de permisos (chmod)"
    echo -e "${RED}[15]${NC} AUDITORÍA COMPLETA"
    echo -e "${RED}[0]${NC} Salir"
    echo -e "${CYAN}══════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}Selecciona una opción [0-15]:${NC} "
    read -r opcion
    case "$opcion" in
        1) info_sistema ;;
        2) auditoria_sistema_avanzada ;;
        3) usuarios_sesion ;;
        4) suid_sgid ;;
        5) analisis_logs_auth || true ;;
        6) inventario_sha256 ;;
        7) recon_dns ;;
        8) conexiones_red ;;
        9) procesos_sospechosos ;;
        10) escaner_puertos ;;
        11) verificar_dependencias ;;
        12) ver_log_sesion ;;
        13) generar_informe || true ;;
        14) gestor_permisos ;;
        15) auditoria_completa || true ;;
        0) clear; echo -e "${GREEN}¡Hasta luego!${NC} Evidencias en: $OUTPUT_DIR"; exit 0 ;;
        *) echo -e "${RED}[!] Opción inválida.${NC}"; sleep 2 ;;
    esac
done

trap 'exit 130' INT
trap 'exit 143' TERM
