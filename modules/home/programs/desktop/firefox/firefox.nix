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

    # Note: The absolute path to config.json is needed here because I am using flakes.
    home.file.".local/share/firefoxpwa/config.json".source = mkIf config.firefox.installPWA (config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-configuration/modules/home/programs/desktop/firefox/config.json");
    home.activation.install-firefoxpwa = mkIf config.firefox.installPWA (hm.dag.entryAfter ["writeBoundary"] ''
      run echo "Activating Firefox PWA"
    '');
  };
}
