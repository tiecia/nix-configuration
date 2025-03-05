{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    gnome.enable = mkEnableOption "Enable GNOME Desktop Environment";
  };

  config = mkIf config.gnome.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
    };

    environment.systemPackages = [
      pkgs.gnome-tweaks
      pkgs.gnomeExtensions.gpu-profile-selector
      pkgs.hunspell
      pkgs.hunspellDicts.en_US
      pkgs.gnomeExtensions.dash-to-dock
    ];

    programs.bash = {
      shellAliases = {
        code = "code --use-gl=desktop";
      };
    };
  };
}
