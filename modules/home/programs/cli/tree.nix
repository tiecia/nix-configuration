{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    tree.enable = mkEnableOption "Enable tree";
  };

  config = mkIf config.tree.enable {
    home.packages = with pkgs; [
      tree
    ];
  };
}
