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