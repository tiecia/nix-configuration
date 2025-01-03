{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    alacritty.enable = lib.mkEnableOption "Enable alacritty";
  };

  config = mkIf config.alacritty.enable {
    home.packages = with pkgs; [
      alacritty
    ];

    home.file = {
      ".config/alacritty2/alacritty-theme" = {
        source = builtins.fetchGit {
          url = "https://github.com/alacritty/alacritty-theme.git";
          rev = "95a7d695605863ede5b7430eb80d9e80f5f504bc";
        };
      };
    };
  };
}
