{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  options = {
    nixos-cli.enable = mkEnableOption "Enable nixos-cli";
  };

  config = mkIf config.nixos-cli.enable {
    services.nixos-cli = {
      enable = true;
      package = inputs.nixos-cli.packages.${pkgs.system}.nixosLegacy;
    };
  };
}
