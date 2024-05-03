{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    steam.enable = mkEnableOption "Enable steam";
  };

  config = mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      steam
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    programs.gamemode.enable = true;
  };
}
