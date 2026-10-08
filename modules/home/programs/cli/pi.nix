{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    pi.enable = mkEnableOption "Enable pi coding agent";
  };

  config = mkIf config.pi.enable {
    home.packages = with pkgs; [
      pi-coding-agent
    ];
  };
}
