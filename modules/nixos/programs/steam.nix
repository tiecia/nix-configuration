{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    steam.enable = mkEnableOption "Enable steam";
    steam.enableGamescope = mkEnableOption "Enable gamescope for steam";
    steam.gamescopeArgs = mkOption {
      type = types.listOf types.string;
      default = [""];
      description = "Arguments to pass to gamescope";
    };
  };

  config = mkIf config.steam.enable {
    environment.systemPackages = with pkgs; [
      steam
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = config.steam.enableGamescope;
      gamescopeSession.args = mkIf config.steam.enableGamescope config.steam.gamescopeArgs;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      # package = pkgs.steam.override {
      # extraPkgs = pkgs:
      # with pkgs; [
      # libkrb5
      # keyutils
      # ];
      # };
    };

    programs.gamemode.enable = true;
  };
}
