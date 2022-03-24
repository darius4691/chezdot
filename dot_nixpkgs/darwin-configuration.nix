{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
    neovim
    tmux
    # required by neovim and common tools
    sumneko-lua-language-server
    luajit
    shellcheck
    aspell
    # COMMANDLINE TOOLS
    fd
    ripgrep
    bat
    exa
    fzf
    wget
    tree
    jq
    perl
    rename
    figlet
    gitFull
    git-lfs
    #delta
    #SYSTEM TOOLS
    ncdu
    procs
    socat
    htop
    # DEVEL TOOLS
    universal-ctags
    global
    cscope
    cmake
    gcc
    libgccjit
    sbcl
    racket-minimal
    luajit
    coreutils
    llvm
    # LITERAL TOOLS
    graphviz
    pandoc
    gnuplot
    #SOFTWARES
    ffmpeg
    imagemagick
    youtube-dl
    libcaca #image to ascii
    aria2 # download manager
    w3m
    gnupg
    pinentry_mac # used for poping up password entering frame
    #nyxt
    ];
  environment.variables.EDITOR = "nvim";
  nixpkgs.overlays = [
    (import (builtins.fetchTarball https://github.com/nix-community/emacs-overlay/archive/master.tar.gz))
    (self: super: {
      neovim = super.neovim.override {
        viAlias = true;
        vimAlias = true;
      };
    })
  ];
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";


  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    binaryCaches = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    extraOptions = ''
      experimental-features = nix-command
    '';
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

