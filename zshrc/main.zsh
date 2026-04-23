ZSHRC_DIR="${0:A:h}"

[[ -f "$ZSHRC_DIR/env.zsh" ]] && source "$ZSHRC_DIR/env.zsh"

for f in "$ZSHRC_DIR"/*.zsh; do
  [[ "$f" == */env.zsh ]] && continue
  [[ "$f" == */main.zsh ]] && continue
  [[ -f "$f" ]] && source "$f"
done
