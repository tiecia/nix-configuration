{
  config,
  lib,
  pkgs,
  pkgs-master,
  pkgs-stable,
  ...
}:
with lib; {
  options = {
    firefox.enable = lib.mkEnableOption "Enable firefox";
    firefox.installPWA = lib.mkEnableOption "Enable PWA";
  };

  config = mkIf config.firefox.enable {
    home = {
      # packages = mkMerge [
      #   [pkgs.firefox]
      #   (mkIf config.firefox.installPWA [pkgs.firefoxpwa])
      # ];

      # Note: The absolute path to config.json is needed here because I am using flakes.
      # file.".local/share/firefoxpwa/config.json" = mkIf config.firefox.installPWA {
      #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-configuration/modules/home/programs/desktop/firefox/config.json";
      # };
      # activation.install-firefoxpwa = mkIf config.firefox.installPWA (hm.dag.entryAfter ["writeBoundary"] ''
      #   run chmod 666 ${config.home.homeDirectory}/nix-configuration/modules/home/programs/desktop/firefox/config.json
      # '');
    };

    programs.firefox = {
      package = pkgs.firefox;
      enable = true;
      nativeMessagingHosts = mkIf config.firefox.installPWA [pkgs.firefoxpwa];
    };
  };
}
