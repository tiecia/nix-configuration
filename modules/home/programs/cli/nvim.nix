{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  options = {
    nvim.enable = lib.mkEnableOption "Enable nvim";
  };

  config = let
    custom-nvim = inputs.custom-nvim.packages.${pkgs.system}.default;
  in
    lib.mkIf config.nvim.enable {
      home.packages = [
        custom-nvim
        pkgs.ripgrep # Needed for telescope
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
