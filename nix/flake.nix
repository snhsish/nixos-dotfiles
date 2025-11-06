{
  description = "snehasish's nixOS flake (with hyprland and devShells)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # hyprland flake (pulls full source + submodules)
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # lanzaboote (for secure boot)
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
  };

  outputs = { self, nixpkgs, hyprland, lanzaboote, ... }@inputs:
    let
      system = "x86_64-linux";

      # import nixpkgs for package access
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # main system config
      nixosConfigurations = {
        snehasish-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs lanzaboote hyprland; };

          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
          ];
        };
      };

      # reproducible dev environment (run with `nix develop`)
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          nodejs
          vim
          gcc
          nixpkgs-fmt
        ];

        shellHook = ''
          echo "snehasish's nixOS devShell"
        '';
      };
    };
}