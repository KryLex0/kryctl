SHELL_NAME=$(basename $SHELL)
BASHRC_FILE="$HOME/.$SHELL_NAME"rc

# check if kryctl is installed
if ! command -v kryctl &> /dev/null; then
  echo "kryctl not found, Installing kryctl..."
  
  # Ensure the lines are present in the BASHRC file
  if ! grep -q "export PATH=\$PATH:$(pwd)" "$BASHRC_FILE"; then
    echo "export PATH=\$PATH:$(pwd)" >> "$BASHRC_FILE"
  fi

  if ! grep -q 'eval "\$(kryctl completions)"' "$BASHRC_FILE"; then
    echo 'eval "$(kryctl completions)"' >> "$BASHRC_FILE"
  fi
else
  echo "kryctl is already installed"
fi