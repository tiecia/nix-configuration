{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    flakes.enable = lib.mkEnableOption "Enable flakes support";
  };

  config = mkIf config.flakes.enable {
    # Enables flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
