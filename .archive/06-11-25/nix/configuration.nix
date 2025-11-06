{ config, pkgs, lib, ... }:

# variables
let
  lanzaboote = import (builtins.fetchTarball "https://github.com/nix-community/lanzaboote/archive/refs/tags/v0.4.2.tar.gz");
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/main.tar.gz";
  }).defaultNix;

in {
  imports =
    [
      ./hardware-configuration.nix
      lanzaboote.nixosModules.lanzaboote
    ];

  # NTFS Support
  boot.supportedFilesystems = [ "ntfs" ];

  # bootloader
  # boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false; # Lanzaboote replaces systemd-boot so force it off
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";  # location of sbctl generated keys
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # GRUB
  #  boot.loader.grub.enable = true;
  #  boot.loader.grub.devices = [ "nodev" ];
  #  boot.loader.grub.efiSupport = true;
  #  boot.loader.grub.useOSProber = true;

  networking.hostName = "snehasish-nixos"; # hostname (using separated - only)
  
  # enable networking
  networking.networkmanager.enable = true;

  # time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager = {
      defaultSession = "hyprland";
  };

  #services.postgresql = {
  #  enable = true;
  #  package = pkgs.postgresql_17_jit;
  #  ensureDatabases = [ "ecomm" ];
  #  authentication = ''
  #    local   all             all                                     trust
  #    host    all             all             127.0.0.1/32            md5
  #    host    all             all             ::1/128                 md5
  #  '';
  #};

  # Hyprland
  programs.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Waybar for Hyprland
  programs.waybar.enable = true;

  # Enable the GNOME Desktop Environment.
  #  services.xserver.displayManager.gdm.enable = true;
  #  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # defining users
  users.users.snehasish = {
    isNormalUser = true;
    description = "snehasish";
    extraGroups = [ "networkmanager" "wheel"  "docker" "dialout" "uucp" ];
    packages = with pkgs; [
      brave
      discord
      vencord
      spotify
      obs-studio
    ];
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.zsh;

  # Enable zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 1000;

    shellAliases = {
      # ...
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';

    #ohMyZsh = {
      #enable = true;
      #plugins = [ "git" "dirhistory" "history" ];
      #theme="powerlevel10k/powerlevel10k";
    #};
  };

  # Install firefox.
  programs.firefox.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # secure boot
    sbctl

    # hyprland
    hyprland
    wofi
    xdg-utils
    xdg-desktop-portal-hyprland    

    # wallpaper
    swww
    sddm-astronaut # for lockscreen

    # terminal
    kitty

    # shell
    zsh
    oh-my-zsh
    zsh-powerlevel10k
    meslo-lgs-nf # nerd font for powerlevel10k

    # utils
    git
    gh
    n8n
    ollama

    nodejs_24
    jdk # java dev kit for android app dev
    android-tools
    cloudflared

    pnpm
    fastfetch
    networkmanagerapplet
    btop

    # editors
    neovim
    vscode
    arduino
    arduino-cli

    # screen (snip + clip)
    grim # screenshot
    wf-recorder # clipping
    slurp # selected are snipping+clipping

    # clipboard
    wl-clipboard
    cliphist

    # notification
    libnotify
    swaynotificationcenter
    jq
    eww

    # sound and audio
    pavucontrol
    playerctl

    # spicetify
    spicetify-cli

    # c tooling
    gcc
    gdb
   
    # theming
    catppuccin-gtk
    catppuccin-cursors
    papirus-icon-theme
    nwg-look
    brightnessctl

    # others
    cbonsai
    cowsay
    pipes

    # anime
    ani-cli

    # file manager
    kdePackages.dolphin
    kdePackages.qtsvg
  ];

  # fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-emoji
  ];

  # Docker
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # enable bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "25.05";
}