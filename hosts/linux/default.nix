{
  pkgs,
  username,
  stateVersion,
  ...
}:

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    home = "/home/${username}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = stateVersion;
}
