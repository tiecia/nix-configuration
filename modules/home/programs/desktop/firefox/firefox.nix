{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    firefox.enable = lib.mkEnableOption "Enable firefox";
    firefox.installPWA = lib.mkEnableOption "Enable PWA";
  };

  config = mkIf config.firefox.enable {
    home.packages = with pkgs;
      mkMerge [
        [firefox]
        (mkIf config.firefox.installPWA [firefoxpwa])
      ];

    programs.firefox = {
      enable = true;
      nativeMessagingHosts = mkIf config.firefox.installPWA [pkgs.firefoxpwa];
    };

    home.file.".local/share/firefoxpwa/config.json".source = mkIf config.firefox.installPWA (config.lib.file.mkOutOfStoreSymlink ./config.json);
  };
}
