{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./nvidia-graphics.nix
    ./printing.nix
    ./stylix.nix
    ./pipewire.nix
    ./bluetooth.nix
    ./logitech.nix
    ./environment-variables.nix
    ./fonts.nix
  ];

  options = {
    desktop-configuration.enable = lib.mkEnableOption "Enable desktop-configuration";
  };

  config = mkIf config.desktop-configuration.enable {
    pipewire.enable = lib.mkDefault true;
    bluetooth.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    nvidia-graphics.enable = lib.mkDefault true;
    logitech.enable = lib.mkDefault true;
    kde-connect.enable = lib.mkDefault true;
    steam.enable = lib.mkDefault true;
    prism-launcher.enable = lib.mkDefault true;
    syncthing.enable = lib.mkDefault true;
    wine.enable = lib.mkDefault true;
  };
}
