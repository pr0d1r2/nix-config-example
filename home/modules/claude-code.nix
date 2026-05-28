{
  pkgs,
  claude-code-nix,
  nix-home-manager-claude-code,
  ...
}:
let
  sys = pkgs.stdenv.hostPlatform.system;
in
{
  disabledModules = [ "programs/claude-code.nix" ];
  imports = [ nix-home-manager-claude-code.homeManagerModules.default ];

  home.packages = [
    claude-code-nix.packages.${sys}.default
  ];

  programs.claude-code = {
    enable = true;
    model = "claude-sonnet-4-6";
    thinkingBudget = "medium";

    presets = {
      autoCommit = true;
      coverage = true;
      justfile = true;
      sessionId = true;
    };

    settings = {
      promptSuggestionEnabled = false;
    };

    env.CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
  };
}
