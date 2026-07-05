{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    github-copilot.enable = mkEnableOption "Enable github-copilot";
  };

  config = mkIf config.github-copilot.enable {
    home.packages = with pkgs; [
      github-copilot-cli
    ];
  };
}
