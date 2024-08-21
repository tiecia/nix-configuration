{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    dynamic-linking.enable = lib.mkEnableOption "Enable dynamic library linking";
  };

  config = mkIf config.dynamic-linking.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
    ];
  };
}
