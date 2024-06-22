{
  config,
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
with lib; {
  options = {
    nvim.enable = mkEnableOption "Enable nvim";
  };

  config = let
    custom-nvim = inputs.custom-nvim.packages.${"x86_64-linux"}.default; # TODO: Figure out how to use system variable
  in
    mkIf config.nvim.enable {
      home.packages = [
        custom-nvim
        pkgs.ripgrep
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          vi = "${custom-nvim}/bin/nvim";
          v = "${custom-nvim}/bin/nvim";
        };
      };
    };
}
