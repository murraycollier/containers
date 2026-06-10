#!/usr/bin/env bash
set -euo pipefail

TMUX_CONFIG_DIR="$HOME/.config/tmux"
TPM_DIR="$TMUX_CONFIG_DIR/plugins/tpm"

# --- Resolve the directory this script lives in ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Create config directory if it doesn't exist ---
mkdir -p "$TMUX_CONFIG_DIR"

# --- Copy tmux config ---
if [[ -f "$SCRIPT_DIR/tmux.conf" ]]; then
  cp "$SCRIPT_DIR/tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"
  echo "✓ Copied tmux.conf → $TMUX_CONFIG_DIR/tmux.conf"
else
  echo "✗ No tmux.conf found in $SCRIPT_DIR — skipping."
fi

# --- Install TPM ---
if [[ -d "$TPM_DIR" ]]; then
  echo "✓ TPM already installed at $TPM_DIR — skipping clone."
else
  echo "→ Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  echo "✓ TPM installed at $TPM_DIR"
fi

echo ""
echo "Done! Open tmux and press prefix + I to install plugins."
