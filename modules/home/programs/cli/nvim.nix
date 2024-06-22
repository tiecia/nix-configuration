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
    custom-nvim = inputs.custom-nvim.packages.${pkgs.system}.default; # TODO: Figure out how to use system variable
    # custom-nvim = inputs.custom-nvim.packages.${"x86_64-linux"}.default; # TODO: Figure out how to use system variable
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
