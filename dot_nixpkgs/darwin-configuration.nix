{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  #systemPackages{{{
  environment.systemPackages = with pkgs;
    [
    # text editor
    neovim emacs tmux
    # required by neovim and common tools
    direnv starship
    luajit sumneko-lua-language-server
    shellcheck aspell luaformatter
    # COMMANDLINE TOOLS
    fd ripgrep bat exa fzf zoxide
    wget tree jq perl rename
    gitFull git-lfs
    #delta
    #SYSTEM TOOLS
    gnupg ncdu procs
    socat htop coreutils
    # DEVEL TOOLS
    universal-ctags global cscope
    gnumake cmake gcc libgccjit llvm
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
    chezmoi
    tealdeer
    #nyxt
    # PYTHON and its packages
    python310
    python310Packages.pygments
    # NODE and its packages
    nodePackages.pyright
  ];
  #}}}
  #fonts = {
  #  #enableFontDir = true;
  #  fonts = with pkgs; [
  #    lxgw-wenkai
  #    sarasa-gothic
  #    fira-code
  #    emacs-all-the-icons-fonts
  #    source-han-sans
  #    source-han-serif
  #  ];
  #};

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
  environment.pathsToLink = [ "/share/zsh" ];
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

  # toggle emacs services
  services.emacs = {
    enable = true;
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  users.users.darius = {
    name = "darius";
    home = "/Users/darius";
  };
  home-manager.users.darius = { pkgs, ... }: {
    fonts.fontconfig.enable = true;
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      autocd = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      sessionVariables = {
        CONDARC = "\${XDG_CONFIG_HOME}/conda/condarc";
        HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
        HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
        NIX_PATH = "\${HOME}/.nix-defexpr/channels\${NIX_PATH:+:}\${NIX_PATH}";
        GO111MODULE = "on";
        GOPATH = "\${HOME}/.local/share/go";
        MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
        FONTCONFIG_PATH = "/opt/X11/lib/X11/fontconfig";
      };
      shellAliases = {
        ll = "${pkgs.exa}/bin/exa -al";
        la = "${pkgs.exa}/bin/exa -a";
        ls = "${pkgs.exa}/bin/exa";
        du = "${pkgs.ncdu}/bin/ncdu";
        top = "${pkgs.htop}/bin/htop";
        ".." = "cd ..";
        cat = "${pkgs.bat}/bin/bat --paging=never";
        e = "emacsclient --no-wait --create-frame --alternate-editor=\"\"";
      };
      plugins = [
        {
          name = "fzf-tab";
          src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        }
      ];
      initExtra = ''
        zstyle ':completion:*:descriptions' format '%d'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
        test -f $ZDOTDIR/local.zsh  && source $ZDOTDIR/local.zsh
      '';
    };
    programs.fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      fileWidgetOptions = [
        "--preview"
        "'bat --style=numbers --color=always {} | head -200'"
      ];
    };
    programs.zoxide.enable = true;
    programs.starship = {
      enable = true;
      settings = {
        character = {
          success_symbol = "[🍀](bold green)";
          error_symbol = "[🍀](bold red)";
        };
      };
    };
    programs.direnv.enable = true;
    programs.gpg = {
      enable = true;
      settings = {
        keyid-format = "0xlong";
        with-fingerprint = true;
        with-keygrip = true;
        expert = true;
      };
    };
    #programs.gnupg.agent = {
    #    enable = true;
    #    enableSSHSupport = true;
    #    sshKeys = [
    #      "D951C57386EE4E7B5A39CED1CFA87B1233770B0A"
    #    ];
    #    pinentryFlavor = "curses";
    #};
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}

