#!/usr/bin/env bash
# uninstall.sh — remove o mklink do sistema
set -euo pipefail

# ─── cores ────────────────────────────────────────────────────────────────
if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
    C_OK=$'\e[38;5;114m'
    C_INFO=$'\e[38;5;110m'
    C_WARN=$'\e[38;5;215m'
    C_ERR=$'\e[38;5;174m'
    C_DIM=$'\e[38;5;245m'
    C_RST=$'\e[0m'
else
    C_OK="" C_INFO="" C_WARN="" C_ERR="" C_DIM="" C_RST=""
fi

ok()   { echo "${C_OK}✔${C_RST} $*"; }
info() { echo "${C_INFO}ℹ${C_RST} $*"; }
warn() { echo "${C_WARN}⚠${C_RST} $*"; }
err()  { echo "${C_ERR}✘${C_RST} $*" >&2; }

# ─── paths ────────────────────────────────────────────────────────────────
BIN="${HOME}/.local/bin/mklink"
DATA_DIR="${HOME}/.config/mklink"
DATA_FILE="${DATA_DIR}/links.tsv"

echo
echo "${C_INFO}╭──────────────────────────────────────────────╮${C_RST}"
echo "${C_INFO}│${C_RST}  🗑️  ${C_WARN}mklink${C_RST} — desinstalador                ${C_INFO}│${C_RST}"
echo "${C_INFO}╰──────────────────────────────────────────────╯${C_RST}"
echo

# ─── flags ────────────────────────────────────────────────────────────────
PURGE=0
ASSUME_YES=0
for arg in "$@"; do
    case "$arg" in
        --purge|-p)   PURGE=1 ;;
        --yes|-y)     ASSUME_YES=1 ;;
        -h|--help)
            cat <<EOF
Uso: ./uninstall.sh [opções]

Opções:
  -p, --purge   Remove também os dados em ~/.config/mklink (links salvos!)
  -y, --yes     Não pergunta confirmação (modo não-interativo)
  -h, --help    Mostra esta ajuda
EOF
            exit 0
            ;;
        *) err "Opção desconhecida: $arg"; exit 1 ;;
    esac
done

confirma() {
    local pergunta="$1" resp
    if (( ASSUME_YES )); then
        return 0
    fi
    read -r -p "$pergunta [s/N]: " resp
    [[ "$resp" =~ ^[sSyY]$ ]]
}

# ─── remove binário ───────────────────────────────────────────────────────
if [[ -e "$BIN" ]]; then
    info "Binário encontrado em: ${C_DIM}${BIN}${C_RST}"
    if confirma "Remover o binário?"; then
        rm -f "$BIN"
        ok "Binário removido."
    else
        warn "Pulando remoção do binário."
    fi
else
    warn "Nenhum binário em ${BIN} (já desinstalado?)."
fi

# ─── remove backups deixados pelo install.sh ──────────────────────────────
shopt -s nullglob
BACKUPS=( "${BIN}.bak-"* )
shopt -u nullglob
if (( ${#BACKUPS[@]} > 0 )); then
    echo
    warn "Encontrei ${#BACKUPS[@]} backup(s) de instalações anteriores:"
    for b in "${BACKUPS[@]}"; do
        echo "       ${C_DIM}${b}${C_RST}"
    done
    if confirma "Remover esses backups?"; then
        rm -f "${BACKUPS[@]}"
        ok "Backups removidos."
    else
        info "Backups mantidos."
    fi
fi

# ─── dados do usuário ─────────────────────────────────────────────────────
echo
if [[ -d "$DATA_DIR" ]]; then
    LINHAS=0
    if [[ -f "$DATA_FILE" ]]; then
        LINHAS=$(wc -l < "$DATA_FILE" 2>/dev/null || echo 0)
    fi
    info "Dados em: ${C_DIM}${DATA_DIR}${C_RST} ${C_DIM}(${LINHAS} link(s) salvo(s))${C_RST}"

    if (( PURGE )); then
        warn "Modo --purge ativo: os dados SERÃO apagados."
        if confirma "Tem certeza? Isto é IRREVERSÍVEL."; then
            rm -rf "$DATA_DIR"
            ok "Diretório de dados removido."
        else
            info "Dados mantidos."
        fi
    else
        info "Dados ${C_OK}preservados${C_RST} (rode com ${C_WARN}--purge${C_RST} para apagar)."
        echo "       Backup rápido: ${C_DIM}cp ${DATA_FILE} ~/links-backup.tsv${C_RST}"
    fi
else
    info "Nenhum diretório de dados encontrado."
fi

# ─── final ────────────────────────────────────────────────────────────────
echo
echo "${C_OK}╭──────────────────────────────────────────────╮${C_RST}"
echo "${C_OK}│${C_RST}  ✅ Desinstalação concluída.                 ${C_OK}│${C_RST}"
echo "${C_OK}╰──────────────────────────────────────────────╯${C_RST}"
echo
echo "  Sentiremos sua falta. 👋"
echo "  Pra reinstalar: ${C_INFO}./install.sh${C_RST}"
echo
