{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options = {
    minecraft-server.enable = lib.mkEnableOption "Enable the vanilla Minecraft server";
  };

  config = {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers = {
        vanilla = lib.mkIf config.minecraft-server.enable {
          enable = true;
          jvmOpts = "-Xmx4G -Xms2G";

          # Specify the custom minecraft server package
          package = pkgs.minecraftServers.vanilla-1-20;
        };
      };
    };
  };
}
