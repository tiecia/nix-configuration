{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    discord.enable = lib.mkEnableOption "Enable discord";
  };

  config = mkIf config.discord.enable {
    home.packages = with pkgs; [
      discord
      vesktop
    ];
  };
}
