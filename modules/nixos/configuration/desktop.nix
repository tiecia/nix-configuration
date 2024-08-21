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
  ];

  options = {
    desktop-configuration.enable = lib.mkEnableOption "Enable desktop-configuration";
  };

  config = mkIf config.desktop-configuration.enable {
    stylix.enable = lib.mkDefault true;
    pipewire.enable = lib.mkDefault true;
    bluetooth.enable = lib.mkDefault true;
    printing.enable = lib.mkDefault true;
    nvidia-graphics.enable = lib.mkDefault true;
    logitech.enable = true;
  };
}
