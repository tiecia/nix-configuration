{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    vim.enable = mkEnableOption "Enable vim";
  };

  config = mkIf config.vim.enable {
    home.packages = with pkgs; [
      vim
    ];
  };
}
