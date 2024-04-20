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
        []
        (mkIf config.firefox.installPWA [firefoxpwa])
      ];

    programs.firefox = {
      enable = true;
      # nativeMessagingHosts = [pkgs.firefoxpwa];
      nativeMessagingHosts = mkIf config.firefox.installPWA [pkgs.firefoxpwa];
    };
  };
}
# environment.systemPackages = with pkgs; [
#   firefoxpwa
# ];
# programs.firefox = {
#   enable = true;
#   nativeMessagingHosts.packages = [pkgs.firefoxpwa];
# };

