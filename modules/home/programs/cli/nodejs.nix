{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    nodejs.enable = mkEnableOption "Enable nodejs";
  };

  config = mkIf config.nodejs.enable {
    home.packages = with pkgs; [
      nodejs
    ];

    home.sessionVariables = {
      PATH = "$HOME/.npm-global/bin:$PATH";
    };
  };
}
