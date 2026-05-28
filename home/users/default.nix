{ pkgs, ... }:

{
  imports = [
    ../modules/claude-code.nix
  ];
  home.language.base = "en_US.UTF-8";

  home.packages = with pkgs; [
    htop
    tree
    bat
    eza
    fzf
    delta
  ];

  programs = {
    git = {
      enable = true;

      lfs.enable = true;

      settings = {
        alias = {
          st = "status -sb";
          a = "add";
          c = "commit";
          ci = "commit";
          ca = "commit --amend";
          co = "checkout";
          br = "branch";
          d = "diff";
          ds = "diff --staged";
          ln = "log --pretty=format:'%Cblue%h %Cred* %C(yellow)%s'";
          s = "show";
          p = "push";
          pf = "push --force-with-lease";
          wt = "worktree";
          wta = "worktree add";
          wtl = "worktree list";
          wtr = "worktree remove";
        };
        extensions.worktreeConfig = true;
        color = {
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
        };
        push.default = "current";
        rebase.autosquash = true;
        core = {
          editor = "vim";
          excludesfile = "~/.gitignore";
        };
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options.navigate = true;
    };

    zsh = {
      enable = true;
      shellAliases = {
        ll = "eza -la";
        gs = "git status";
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" ];
      };
      initContent = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;
  };
}
