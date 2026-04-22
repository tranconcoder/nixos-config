#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# Arch Linux package installer for Neovim setup
# Covers: Neovim, build tools, clipboard,
#         Node/npm, Python, C/C++ toolchain,
#         fonts, and runtime dependencies
# ──────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { printf "${GREEN}[INFO]${NC}  %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$*"; }

# ── Require root / sudo ──────────────────────
if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root. It will call sudo when needed."
    exit 1
fi

# ── Check for yay ─────────────────────────────
if ! command -v yay &>/dev/null; then
    warn "yay not found — installing yay from AUR..."
    sudo pacman -S --needed --noconfirm base-devel git
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$tmpdir/yay-bin"
    (cd "$tmpdir/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    info "yay installed successfully"
fi

# ── Pacman packages ──────────────────────────
PACMAN_PKGS=(
    # Neovim
    neovim

    # Build essentials (telescope-fzf-native, LuaSnip jsregexp, treesitter compilers)
    base-devel
    cmake
    make
    gcc

    # Git (lazy.nvim bootstrap, gitsigns)
    git

    # Clipboard provider (unnamedplus)
    xclip
    wl-clipboard

    # Lua / LuaJIT (LuaSnip jsregexp build)
    luajit
    lua

    # Node.js & npm (Mason LSP installs, prettier, eslint, ts_ls)
    nodejs
    npm

    # Python (pyright, debugpy, ruff, python DAP)
    python
    python-pip
    python-virtualenv

    # C/C++ toolchain (clangd, clang-format, clang-tidy)
    clang
    lldb

    # Telescope live_grep dependency
    ripgrep

    # Telescope find_files dependency
    fd

    # Tree-sitter CLI (optional, for :TSInstallFromGrammar)
    tree-sitter

    # Nerd Font rendering (nvim-web-devicons)
    ttf-nerd-fonts-symbols-mono

    # Unzip (Mason needs it to extract some packages)
    unzip
    wget
    curl
    gzip
    tar

    # avante.nvim build dependencies
    rust
    cargo
    luarocks
)

info "Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"

# ── AUR packages (via yay) ───────────────────
AUR_PKGS=(
    # Nerd Font (full patched font for terminal)
    ttf-jetbrains-mono-nerd
)

info "Installing AUR packages..."
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

# ── npm global packages (Mason fallback) ─────
info "Installing global npm packages..."
sudo npm install -g neovim

# ── Python provider ──────────────────────────
info "Installing Python neovim provider..."
pip install --user --break-system-packages pynvim 2>/dev/null || pip install --user pynvim

# ── Post-install summary ─────────────────────
echo ""
info "════════════════════════════════════════════"
info "  All packages installed!"
info "════════════════════════════════════════════"
info ""
info "Next steps:"
info "  1. Set your terminal font to 'JetBrainsMono Nerd Font'"
info "  2. Launch nvim — lazy.nvim will auto-install plugins + build avante.nvim"
info "  3. Run :Mason to install LSP servers:"
info "       :MasonInstall lua-language-server"
info "       :MasonInstall typescript-language-server"
info "       :MasonInstall pyright"
info "       :MasonInstall clangd"
info "       :MasonInstall prettier eslint_d"
info "       :MasonInstall stylua"
info "  4. Run :checkhealth to verify everything"
info ""
