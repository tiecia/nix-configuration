{
  config,
  lib,
  pkgs,
  ...
}: let
  configDir = config.home.homeDirectory + "/.quickemu";
  windows11-setup = pkgs.writeShellScriptBin "windows11-setup" ''
    mkdir -p ${configDir}
    cd ${configDir} || exit
    quickget windows 11
    quickemu --vm windows-11.conf --shortcut
  '';
in
  with lib; {
    options = {
      quickemu.enable = lib.mkEnableOption "Enable quickemu";
    };

    config = mkIf config.quickemu.enable {
      home.packages = with pkgs; [
        quickemu
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          windows11-setup = "bash ${windows11-setup}/bin/windows11-setup";
          windows11 = "quickemu --vm ${configDir}/windows-11.conf --display spice";
        };
      };
    };
  }
