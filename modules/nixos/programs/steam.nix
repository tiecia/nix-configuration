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
      gamescopeSession.enable = true;
      # gamescopeSession.args = ["-w 1920 -h 1080 -W 2560 -H 1080 -f"];
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            libkrb5
            keyutils
          ];
      };
    };

    programs.gamemode.enable = true;
  };
}
