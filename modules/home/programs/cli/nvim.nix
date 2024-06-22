{
  config,
  lib,
  inputs,
  system,
  ...
}:
with lib; {
  options = {
    nvim.enable = mkEnableOption "Enable nvim";
  };

  config = let
    custom-nvim = inputs.custom-nvim.packages.${"x86_64-linux"}.default;
    #custom-nvim = inputs.custom-nvim;
  in
    mkIf config.nvim.enable {
      home.packages = [
        custom-nvim
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
