{
  config,
  lib,
  options,
  pkgs,
  ...
}: {
  options = {
    minecraft-server.enable = lib.mkEnableOption "Enable the vanilla Minecraft server";
  };

  config = lib.optionalAttrs (options.services ? minecraft-servers) (lib.mkIf config.minecraft-server.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      servers = {
        vanilla = {
          enable = true;
          jvmOpts = "-Xmx4G -Xms2G";

          # Specify the custom minecraft server package
          package = pkgs.minecraftServers.vanilla-1-20;
        };
      };
    };
  });
}
