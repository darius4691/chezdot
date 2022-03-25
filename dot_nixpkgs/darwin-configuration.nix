{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [
    neovim tmux
    # required by neovim and common tools
    direnv
    luajit sumneko-lua-language-server
    shellcheck aspell
    # COMMANDLINE TOOLS
    fd ripgrep bat exa fzf
    wget tree jq perl rename
    gitFull git-lfs
    #delta
    #SYSTEM TOOLS
    gnupg ncdu procs
    socat htop coreutils
    # DEVEL TOOLS
    universal-ctags global cscope
    cmake gcc libgccjit
    sbcl racket-minimal
    # LITERAL TOOLS
    graphviz pandoc gnuplot
    texlive.combined.scheme-full
    #SOFTWARES
    ffmpeg
    imagemagick
    youtube-dl
    libcaca #image to ascii
    aria2 # download manager
    w3m
    pinentry_mac # used for poping up password entering frame
    figlet
    #nyxt
    ];
  environment.variables = rec {
    EDITOR = "nvim";
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";
    ZDOTDIR = "\${XDG_CONFIG_HOME}/zsh";
    PATH = [
      "\${XDG_BIN_HOME}:\${PATH}"
    ];
  };
  nixpkgs.overlays = [
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
  programs.zsh.enable = true;
  users.users.darius = {
    name = "darius";
    home = "/Users/darius";
  };
  home-manager.users.darius = { pkgs, ... }: {
    programs.gpg = {
      
    };
    #programs.gnupg.agent = {
    #    enable = true;
    #    enableSSHSupport = true;
    #    sshKeys = [
    #      "D951C57386EE4E7B5A39CED1CFA87B1233770B0A"
    #    ];
    #    extraConfig = ''
    #      keyid-format 0xlong
    #      with-fingerprint
    #      with-keygrip
    #      expert
    #    '';
    #    pinentryFlavor = "curses";
    #};
    programs.fish = {
      enable = true;
      shellAliases = {
        ll = "exa -al";
        la = "exa -a";
        ls = "exa";
        du = "ncdu";
        top = "htop";
        ".." = "cd ..";
      };
      shellInit = ''
        set -x SHELL /bin/bash
        direnv hook fish | source
        set -e SSH_AGENT_PID
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        set -gx GPG_TTY (tty)
        gpg-connect-agent updatestartuptty /bye >/dev/null
      '';
    };
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

