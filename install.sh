#!/usr/bin/env bash
# install.sh — instala o mklink em ~/.local/bin
set -euo pipefail

# ─── cores ────────────────────────────────────────────────────────────────
if [[ -t 1 ]] && [[ -z "${NO_COLOR:-}" ]]; then
    C_OK=$'\e[38;5;114m'    # verde pastel
    C_INFO=$'\e[38;5;110m'  # azul pastel
    C_WARN=$'\e[38;5;215m'  # laranja pastel
    C_ERR=$'\e[38;5;174m'   # vermelho pastel
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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${SCRIPT_DIR}/bin/mklink"
DEST_DIR="${HOME}/.local/bin"
DEST="${DEST_DIR}/mklink"

echo
echo "${C_INFO}╭──────────────────────────────────────────────╮${C_RST}"
echo "${C_INFO}│${C_RST}  🔗 ${C_OK}mklink${C_RST} — instalador                    ${C_INFO}│${C_RST}"
echo "${C_INFO}╰──────────────────────────────────────────────╯${C_RST}"
echo

# ─── verifica source ──────────────────────────────────────────────────────
if [[ ! -f "$SRC" ]]; then
    err "Não encontrei o binário em: $SRC"
    err "Rode o instalador a partir da raiz do repositório."
    exit 1
fi

# ─── verifica sintaxe do script antes de instalar ─────────────────────────
info "Validando sintaxe do mklink…"
if ! bash -n "$SRC"; then
    err "Falha de sintaxe em $SRC — abortando."
    exit 1
fi
ok "Sintaxe OK."

# ─── verifica deps obrigatórias ───────────────────────────────────────────
info "Verificando dependências…"
MISSING=()
for cmd in bash awk sed grep sort mktemp xdg-open; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        MISSING+=("$cmd")
    fi
done
if (( ${#MISSING[@]} > 0 )); then
    err "Dependências faltando: ${MISSING[*]}"
    err "Instale-as antes de continuar (ex.: sudo apt install xdg-utils coreutils)."
    exit 1
fi
ok "Todas as dependências obrigatórias presentes."

# fzf é opcional
if command -v fzf >/dev/null 2>&1; then
    ok "fzf detectado — comando 'f' habilitado."
else
    warn "fzf não encontrado (opcional). O comando 'f' ficará desabilitado."
fi

# ─── cria destino ─────────────────────────────────────────────────────────
mkdir -p "$DEST_DIR"

# ─── backup se já existir ─────────────────────────────────────────────────
if [[ -e "$DEST" ]]; then
    BACKUP="${DEST}.bak-$(date +%Y%m%d-%H%M%S)"
    warn "Já existe um mklink instalado. Fazendo backup em:"
    echo "       ${C_DIM}${BACKUP}${C_RST}"
    cp -p "$DEST" "$BACKUP"
fi

# ─── instala ──────────────────────────────────────────────────────────────
info "Instalando em: ${DEST}"
install -m 755 "$SRC" "$DEST"
ok "Binário instalado (modo 755)."

# ─── verifica PATH ────────────────────────────────────────────────────────
echo
if echo ":$PATH:" | grep -q ":${DEST_DIR}:"; then
    ok "${DEST_DIR} já está no seu PATH."
else
    warn "${DEST_DIR} NÃO está no seu PATH."
    echo
    echo "  Adicione esta linha ao seu ${C_INFO}~/.bashrc${C_RST} (ou ~/.zshrc):"
    echo
    echo "      ${C_OK}export PATH=\"\$HOME/.local/bin:\$PATH\"${C_RST}"
    echo
    echo "  Depois recarregue:  ${C_DIM}source ~/.bashrc${C_RST}"
fi

# ─── final ────────────────────────────────────────────────────────────────
echo
echo "${C_OK}╭──────────────────────────────────────────────╮${C_RST}"
echo "${C_OK}│${C_RST}  ✅ Instalação concluída!                    ${C_OK}│${C_RST}"
echo "${C_OK}╰──────────────────────────────────────────────╯${C_RST}"
echo
echo "  Experimente agora:"
echo "    ${C_INFO}mklink -h${C_RST}      → ajuda"
echo "    ${C_INFO}mklink add${C_RST}     → adicionar primeiro link"
echo "    ${C_INFO}mklink${C_RST}         → listar"
echo
