{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    claude-code.enable = mkEnableOption "Enable claude-code";
  };

  config = mkIf config.claude-code.enable {
    home.packages = with pkgs; [
      claude-code
    ];
  };
}
