{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    xbindkeys.enable = mkEnableOption "Enable xbindkeys";

    # xbindkeys.mxmaster-playpause.enable = mkEnableOption "Remap forward button to play/pause on MX Master";
  };

  config = mkIf config.xbindkeys.enable {
    home.file.".xbindkeysrc".source = ./xbindkeysrc;

    home.packages = with pkgs; [
      xbindkeys
      xautomation
    ];

    # Note: Automatic startup of xbindkeys is managed by Plasma under Autostart setting.

    # Start the service on startup
    # systemd.user.services.xbindkeys = {
    #   Unit.Description = "xbindkeys hotkey daemon";
    #   Service = {
    #     ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys";
    #     # Restart = "always"; # Restart service if it crashes
    #   };
    #   Install.WantedBy = ["default.target"]; # Start service on boot
    # };
  };
}
