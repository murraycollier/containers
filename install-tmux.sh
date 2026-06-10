#!/usr/bin/env bash
set -euo pipefail

TMUX_CONFIG_DIR="$HOME/.config/tmux"
TPM_DIR="$TMUX_CONFIG_DIR/plugins/tpm"
TMUX_CONF_URL="https://raw.githubusercontent.com/murraycollier/containers/refs/heads/main/tmux.conf"

# --- Install git if not present ---
if ! command -v git &>/dev/null; then
  echo "→ git not found, installing..."
  if command -v apt-get &>/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y git
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y git
  elif command -v pacman &>/dev/null; then
    sudo pacman -Sy --noconfirm git
  elif command -v brew &>/dev/null; then
    brew install git
  elif [[ "$(uname)" == "Darwin" ]]; then
    echo "→ Triggering macOS Xcode CLI tools install (includes git)..."
    xcode-select --install
    echo "  Re-run this script once the Xcode CLI tools have finished installing."
    exit 1
  else
    echo "✗ Could not detect a package manager to install git. Please install it manually."
    exit 1
  fi
  echo "✓ git installed"
else
  echo "✓ git already installed"
fi

# --- Create config directory if it doesn't exist ---
mkdir -p "$TMUX_CONFIG_DIR"

# --- Download tmux config ---
echo "→ Downloading tmux.conf..."
if command -v wget &>/dev/null; then
  wget -qO "$TMUX_CONFIG_DIR/tmux.conf" "$TMUX_CONF_URL"
elif command -v curl &>/dev/null; then
  curl -sSL "$TMUX_CONF_URL" -o "$TMUX_CONFIG_DIR/tmux.conf"
else
  echo "✗ Neither wget nor curl found. Please install one and re-run."
  exit 1
fi
echo "✓ tmux.conf downloaded → $TMUX_CONFIG_DIR/tmux.conf"

# --- Install TPM ---
if [[ -d "$TPM_DIR" ]]; then
  echo "✓ TPM already installed at $TPM_DIR — skipping."
else
  echo "→ Installing TPM..."
  mkdir -p "$TPM_DIR"
  if command -v wget &>/dev/null; then
    wget -qO /tmp/tpm.tar.gz https://github.com/tmux-plugins/tpm/archive/refs/heads/master.tar.gz
  elif command -v curl &>/dev/null; then
    curl -sSL https://github.com/tmux-plugins/tpm/archive/refs/heads/master.tar.gz -o /tmp/tpm.tar.gz
  else
    echo "✗ Neither wget nor curl found. Please install one and re-run."
    exit 1
  fi
  tar -xzf /tmp/tpm.tar.gz --strip-components=1 -C "$TPM_DIR"
  rm /tmp/tpm.tar.gz
  echo "✓ TPM installed at $TPM_DIR"
fi

echo ""
echo "Done! Open tmux and press prefix + I to install plugins."
