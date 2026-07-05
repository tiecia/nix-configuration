{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    surface.enable = lib.mkEnableOption "Enable configuration for Microsoft Surface devices";
  };

  config = mkIf config.surface.enable {
    environment.systemPackages = with pkgs; [
      surface-control
    ];

    boot.kernelPatches = [
      {
        name = "disable-rust";
        patch = null;
        structuredExtraConfig = with lib.kernel; {
          RUST = lib.mkForce no;
        };
      }
    ];
  };
}
