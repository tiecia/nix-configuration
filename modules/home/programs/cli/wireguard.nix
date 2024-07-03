{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    wireguard.enable = mkEnableOption "Enable wireguard";
  };

  config = mkIf config.wireguard.enable {
    home.packages = with pkgs; [
      wireguard-tools
    ];

    programs.bash = {
      enable = true;
      shellAliases = {
        vpntvup = "sudo wg-quick up ~/TVWireguard.conf";
        vpntvdown = "sudo wg-quick down ~/TVWireguard.conf";
      };
    };
  };
}
