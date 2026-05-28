{ pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    ripgrep
    fd
    jq
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  system.stateVersion = 6;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };
}
