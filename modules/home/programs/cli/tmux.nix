{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    tmux.enable = mkEnableOption "Enable tmux";
  };

  config = mkIf config.tmux.enable {
    home.packages = with pkgs; [
      tmux
    ];
    programs.tmux.escapeTime = 0;
  };
}
