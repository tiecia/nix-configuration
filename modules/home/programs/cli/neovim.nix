{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    neovim.enable = mkEnableOption "Enable neovim";
  };

  config =
    mkIf config.neovim.enable {
    };
}
