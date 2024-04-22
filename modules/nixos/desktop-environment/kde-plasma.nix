{
  config,
  lib,
  pkgs,
  # plasma-manager,
  ...
}:
with lib; {
  options = {
    plasma.enable = mkEnableOption "Enable KDE Plasma Desktop Environment";
  };

  config = mkIf config.plasma.enable {
    # imports = [
    # plasma-manager.homeManagerModules.plasma-manager
    # ];
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
