# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/snehasish/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Alias for quick access
alias nixpfs="sudo nix-env --list-generations --profile /nix/var/nix/profiles/system"
alias nixdeletepfs="sudo nix-env --delete-generations old"
alias nixgarbagecollect="sudo nix-collect-garbage"

# Alias for editing config files
alias nixconfig="sudo nvim /etc/nixos"
alias hyprconfig="code ~/.config/hypr"
alias kittyconfig="code ~/.config/kitty"
alias waybarconfig="code ~/.config/waybar"
alias bashconfig="code ~/.bashrc"
alias zshconfig="code ~/.zshrc"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/powerlevel10k/powerlevel10k.zsh-theme

export PATH=$PATH:/home/snehasish/.spicetify

# pnpm
export PNPM_HOME="/home/snehasish/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end