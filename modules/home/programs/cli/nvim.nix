{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    vim.enable = mkEnableOption "Enable nvim";
  };

  config = mkIf config.vim.enable {
    imports = [
      ../../../../nvim
    ];
    home.packages = with pkgs; [
      nixvim
    ];
  };
}
