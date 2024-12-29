{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    wireshark.enable = mkEnableOption "Enable wireshark";
  };

  config = mkIf config.wireshark.enable {
    environment.systemPackages = [
      pkgs.wireshark
    ];

    # Installs the program and registers the proper user groups.
    # https://search.nixos.org/options?channel=unstable&show=programs.wireshark.enable&from=0&size=50&sort=relevance&type=packages&query=wireshark
    programs.wireshark.enable = true;
  };
}
