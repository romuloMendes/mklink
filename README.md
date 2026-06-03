# 🔗 mklink

> **Gerenciador de links de leitura em linha de comando — rápido, local e sem firula.**
> Pensado para quem lê muito (mangás, artigos, documentação, novels, blogs) e não quer mais depender de **abas abertas eternamente**, **favoritos do navegador** ou **serviços de terceiros** (Notion, Pocket, Raindrop…).

[![Bash](https://img.shields.io/badge/bash-5.x-1f425f.svg)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform: Linux](https://img.shields.io/badge/platform-linux-lightgrey.svg)]()
[![No dependencies](https://img.shields.io/badge/deps-coreutils%20only-brightgreen.svg)]()

---

## 📑 Sumário

- [😤 Por que isto existe?](#-por-que-isto-existe)
- [✨ Funcionalidades](#-funcionalidades)
- [📸 Demo](#-demo)
- [🚀 Instalação](#-instalação)
- [🧭 Uso rápido](#-uso-rápido)
- [📖 Modo leitura (anti link-lixo)](#-modo-leitura-anti-link-lixo)
- [🗂️ Comandos completos](#️-comandos-completos)
- [📂 Onde os dados ficam](#-onde-os-dados-ficam)
- [🔄 Migrações automáticas](#-migrações-automáticas)
- [🎨 Personalização](#-personalização)
- [🤔 Por que não usar X?](#-por-que-não-usar-x)
- [🛠️ Requisitos](#️-requisitos)
- [🗑️ Desinstalação](#️-desinstalação)
- [🙋 Contribuindo](#-contribuindo)
- [📜 Licença](#-licença)

---

## 😤 Por que isto existe?

Sinceramente? Cansei.
Eu estava cansado de viver com **40, 50, 80 abas abertas** como se o navegador fosse uma extensão da minha memória.
Cada aba aberta ocupava espaço mental.
Não era só a memoria da minha cabeça cheia (RAM), era atenção fragmentada, contexto pendente e a sensação constante de que eu estava esquecendo alguma coisa importante.

> _"Não quero estar mantendo muitas abas abertas no navegador, nem usando os favoritos — eles não atendem o que eu preciso para **lembrar de onde parei** e, depois de um tempo, vira muito **link lixo**: coisa que já li misturada com coisa que não li."_

E o pior: mesmo deixando tudo aberto “pra depois”, eu ainda perdia tempo tentando responder perguntas simples:

1. _“Em qual página eu parei?”_
2. _“Esse artigo eu já li ou ainda está pendente?”_
3. _“Por que eu ainda estou guardando esse link aberto há 3 semanas?”_

Os favoritos do navegador também nunca resolveram isso direito:

- 🪦 viram um **cemitério digital** de links esquecidos
- 🧠 não aliviam a carga mental — só escondem o problema em outra UI
- 📖 não salvam contexto real (página, capítulo, episódio, progresso)
- 🔍 não diferenciam algo já consumido de algo pendente
- 🏷️ organização por pastas escala mal e vira burocracia
- 🐘 navegadores modernos já são pesados por natureza — dezenas de abas só pioram

E além disso, eu queria **reduzir minha dependência de ecossistemas fechados e plataformas centralizadas**.

Cada extensão, sync cloud, login obrigatório ou app “gratuito” normalmente significa:

- telemetria,
- tracking,
- dados presos numa plataforma,
- atualizações forçadas,
- e mais uma camada de software entre mim e algo que deveria ser só… um link.

Então eu fiz o oposto.

O **`mklink`** resolve isso com 3 ideias simples:

1. 🆕 **Marca visual** — links nunca lidos aparecem com `🆕`; lidos com `📖`.
2. ⏱️ **`LAST_TS`** — guarda quando você acessou pela última vez (timestamp + “há X dias”).
3. 📍 **Página e capítulo** — pra cada link você grava onde parou (`Cap. 47`, `pág. 312`), sem depender da memória.

Tudo isso em **um único arquivo `.tsv` local**, num CLI que abre em milissegundos.

**`mklink`** é um gerenciador de links minimalista feito para funcionar como memória externa consciente:

- um único arquivo TSV
- um script Bash
- dados locais
- legível com `cat`
- sem nuvem
- sem conta
- sem banco de dados
- sem Electron
- sem JavaScript
- sem analytics
- sem feed infinito tentando sequestrar atenção

Só links, contexto e controle.

O objetivo não é “salvar links”.

É:

- liberar espaço mental,
- reduzir fricção,
- parar de usar abas como TODO list,
- e recuperar ownership sobre a própria navegação.

---

## ✨ Funcionalidades

- ✅ **100% local** — um TSV em `~/.config/mklink/links.tsv`. Sem nuvem, sem API, sem login, sem telemetria.
- ✅ **Marcadores 🆕 / 📖** — bate o olho e sabe o que falta ler.
- ✅ **Continuação de leitura** — guarda página/capítulo/última visita pra cada link.
- ✅ **Modo leitura bloqueante** — abre o link, espera você terminar e atualiza tudo automaticamente.
- ✅ **Categorias e tags** — organize por `mangas`, `artigos`, `docs`, `#dark-fantasy`, etc.
- ✅ **Busca rápida** — por texto, por tag (`#tag`), por categoria, ou via `fzf` (opcional).
- ✅ **Contador de acessos** — descubra quais links você realmente revisita.
- ✅ **Atalhos numéricos** — `5` abre o link da linha 5. Sem mouse, sem mais nada.
- ✅ **Paleta pastel 256 cores** — legível em terminal escuro/transparente.
- ✅ **Migrações automáticas** — atualiza o TSV pra novas colunas sem perder dado.
- ✅ **Zero dependências exóticas** — só `bash`, `awk`, `sed`, `grep`, `sort`, `mktemp`, `xdg-open`.

---

## 📸 Demo

```text
╭──────────────────────────────────────────────────────────────────────────╮
│  🔗 mklink — seus links de leitura                                       │
├──────────────────────────────────────────────────────────────────────────┤
│  #  │ St │ Nome                              │ Cap.   │ Última visita    │
├─────┼────┼───────────────────────────────────┼────────┼──────────────────┤
│  1  │ 📖 │ Solo Leveling                     │ 179    │ há 2 dias        │
│  2  │ 🆕 │ The Beginning After The End       │ —      │ —                │
│  3  │ 📖 │ Tower of God                      │ 588    │ há 6 horas       │
│  4  │ 🆕 │ Laravel 11 release notes          │ —      │ —                │
│  5  │ 📖 │ Refactoring (Fowler) — cap. 6     │ p.142  │ há 1 semana      │
╰──────────────────────────────────────────────────────────────────────────╯

❯ 3
🌐 Abrindo: Tower of God …
📖 Você está no capítulo 588.
[ENTER quando terminar de ler] _
```

Apertou ENTER? Ele bumpa o contador, atualiza `LAST_TS`, troca 🆕 → 📖 e pergunta o novo capítulo.

---

## 🚀 Instalação

### Opção 1 — script (recomendado)

```bash
git clone git@github.com:romuloMendes/mklink.git
cd mklink
chmod +x install.sh
./install.sh
```

Isso copia o binário para `~/.local/bin/mklink` (modo `755`).

> ⚠️ **Após instalar: feche o terminal e abra um novo.** O instalador já configura o PATH automaticamente, mas a mudança só vale em terminais abertos depois.

### Opção 2 — manual

```bash
git clone git@github.com:romuloMendes/mklink.git
install -m 755 mklink/mklink ~/.local/bin/mklink
```

### ⚠️ PATH

Garanta que `~/.local/bin` está no seu `PATH`. Adicione ao seu `~/.bashrc` (ou `~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Depois: `source ~/.bashrc` (ou abra um terminal novo).

Confira:

```bash
which mklink
# /home/seu-usuario/.local/bin/mklink
```

---

## 🧭 Uso rápido

```bash
# Lista tudo
mklink
mklink list
mklink ls

# Adicionar um link (modo interativo)
mklink add

# Adicionar inline
mklink add "Solo Leveling" "https://exemplo.com/sl" mangas

# Abrir o link da linha 3
mklink 3
mklink o3

# Modo leitura bloqueante (abre + espera + atualiza página)
mklink l3
mklink ler 3

# Definir página/capítulo atual do link 3
mklink s3 188        # set page = 188
mklink c3 "Arco 7"   # set capítulo

# Remover o link da linha 5
mklink r5
mklink rm 5

# Buscar por fzf (precisa de fzf instalado)
mklink f

# Mostrar ajuda completa
mklink -h
```

---

## 📖 Modo leitura (anti link-lixo)

Esse é o **coração** do `mklink`. Em vez de só abrir o navegador e te deixar perdido:

```bash
mklink l3
```

O que acontece:

1. 🌐 Abre o link no navegador padrão (`xdg-open`).
2. 📖 Mostra a página/capítulo onde você parou.
3. ⏸️ **Bloqueia** o terminal esperando você apertar ENTER.
4. ⬆️ Incrementa o **CONTADOR** (`+1` acesso).
5. ⏱️ Atualiza `LAST_TS` para agora.
6. 🔄 Marca como 📖 (se ainda era 🆕).
7. ❓ Pergunta: _“Em que página/capítulo você parou?”_ — e grava.

Resultado: você sempre sabe o que **já leu**, o que **nunca abriu**, e **onde parou** em cada coisa.

---

## 🗂️ Comandos completos

| Comando                         | Atalho    | O que faz                                     |
| ------------------------------- | --------- | --------------------------------------------- |
| `mklink`                        | —         | Lista todos os links com marcador 🆕/📖       |
| `mklink list` / `ls`            | —         | Idem                                          |
| `mklink add`                    | `+` / `a` | Adiciona link (interativo ou inline)          |
| `mklink <N>`                    | `oN`      | Abre o link da linha N                        |
| `mklink l <N>` / `ler <N>`      | `lN`      | **Modo leitura** (abre + bloqueia + atualiza) |
| `mklink s <N> <valor>`          | `sN`      | Define página atual                           |
| `mklink c <N> <texto>`          | `cN`      | Define capítulo/arco                          |
| `mklink edit <N>`               | —         | Edita nome/URL/categoria do link              |
| `mklink rm <N>` / `remove`      | `rN`      | Remove o link da linha N                      |
| `mklink mangas` / `m`           | `m`       | Filtra só categoria `mangas`                  |
| `mklink fzf` / `f`              | `f`       | Picker interativo via `fzf`                   |
| `mklink /texto`                 | —         | Busca por texto                               |
| `mklink #tag`                   | —         | Busca por tag                                 |
| `mklink -h` / `--help` / `help` | —         | Ajuda                                         |
| `q`                             | —         | Sai (no modo interativo)                      |

> 💡 **Dica:** quase tudo aceita atalho colado: `o5`, `l5`, `r5`, `s5 142`, `c5 "Cap. 7"`.

---

## 📂 Onde os dados ficam

```
~/.config/mklink/links.tsv
```

Um único arquivo TSV (Tab-Separated Values), 8 colunas:

| #   | Coluna      | Tipo    | Descrição                                 |
| --- | ----------- | ------- | ----------------------------------------- |
| 1   | `NOME`      | string  | Título amigável                           |
| 2   | `URL`       | string  | URL completa                              |
| 3   | `CATEGORIA` | string  | `mangas`, `artigos`, `docs`, livre…       |
| 4   | `LAST_TS`   | unix ts | Última visita (`0` = nunca → marcador 🆕) |
| 5   | `PAGINA`    | string  | Página atual (ex.: `142`, `p.142`)        |
| 6   | `TAGS`      | csv     | `dark-fantasy,coreano,manhwa`             |
| 7   | `CONTADOR`  | int     | Quantas vezes você abriu                  |
| 8   | `CAPITULO`  | string  | Capítulo/arco (ex.: `Cap. 588`)           |

**Quer fazer backup?** Copia esse arquivo. Pronto. Coloca num dotfiles, num git privado, num pen drive — é seu.

```bash
cp ~/.config/mklink/links.tsv ~/backup-links-$(date +%F).tsv
```

---

## 🔄 Migrações automáticas

Toda vez que o `mklink` roda, ele verifica o número de colunas do TSV e adiciona as que faltarem (sem perder dado). Versões antigas com 3 ou 5 colunas migram automaticamente pra estrutura atual de 8 colunas.

> 🛡️ Antes de migrar, ele faz cópia em `~/.config/mklink/links.tsv.bak-<timestamp>`.

---

## 🎨 Personalização

Tudo via variáveis de ambiente (ou edição direta no script):

```bash
# Editor preferido pra editar TSV manualmente
export MKLINK_EDITOR="${EDITOR:-nano}"

# Browser (default: xdg-open)
export MKLINK_OPENER="firefox"

# Forçar paleta sem cor (ex.: pipes / logs)
export NO_COLOR=1
```

A paleta usa 256 cores ANSI pastéis (legível em fundo escuro/transparente).

---

## 🤔 Por que não usar X?

| Alternativa              | Por que não me serve                                            |
| ------------------------ | --------------------------------------------------------------- |
| **Favoritos do browser** | Não sei o que já li, não tem página, vira lixo em 1 mês.        |
| **Pocket / Instapaper**  | Cloud-dependente, ofusca URL, formatação destrói mangás/manhwa. |
| **Notion / Obsidian**    | Overkill pra uma lista de URLs. Lentos. Sync travado em conta.  |
| **Raindrop.io**          | Bom, mas: SaaS, login, limite no free, sem “onde parei”.        |
| **Arquivo de texto**     | É exatamente isso — só que com CLI bonita e comandos curtos.    |

O `mklink` **é** o arquivo de texto. Só que com superpoderes e atalhos.

---

## 🛠️ Requisitos

- **Bash** 5.x (geralmente já vem no Linux)
- **Coreutils**: `awk`, `sed`, `grep`, `sort`, `mktemp` (universal)
- **`xdg-open`** (pacote `xdg-utils` — quase sempre já instalado)
- **`fzf`** _(opcional)_ — apenas pro comando `f`/picker fuzzy

Testado em: Debian 12, Ubuntu 22.04+, Arch, Fedora 39.

```bash
# Debian/Ubuntu
sudo apt install bash coreutils xdg-utils fzf

# Arch
sudo pacman -S bash coreutils xdg-utils fzf

# Fedora
sudo dnf install bash coreutils xdg-utils fzf
```

---

## 🗑️ Desinstalação

```bash
cd mklink
./uninstall.sh
```

Ou manualmente:

```bash
rm ~/.local/bin/mklink

# Se quiser apagar TAMBÉM seus links (cuidado!):
rm -rf ~/.config/mklink
```

---

## 🙋 Contribuindo

PRs são bem-vindas! Algumas ideias na fila:

- [ ] Export/import JSON
- [ ] Sync opcional via git (commit automático do TSV)
- [ ] Comando `stats` (total lido, mais acessados, streak)
- [ ] Suporte a múltiplos perfis (`MKLINK_PROFILE=trabalho mklink`)
- [ ] Integração com `rofi`/`dmenu`

**Antes de abrir PR:**

```bash
bash -n bin/mklink   # validação de sintaxe
shellcheck bin/mklink  # opcional, recomendado
```

Abra uma issue antes pra features grandes 🙏.

---

## 📜 Licença

[MIT](LICENSE) © 2026 **romulo_codes**

---

<p align="center">
  Feito com 🖤 em <code>bash</code> puro, num terminal escuro, à base de café e uma mente cheia de abas abertas.
</p>
