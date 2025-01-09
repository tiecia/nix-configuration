{
  config,
  lib,
  # system,
  winapps-pkgs,
  pkgs,
  ...
}:
with lib; {
  options = {
    winapps.enable = mkEnableOption "Enable winapps";
  };

  config = mkIf config.winapps.enable {
    environment.systemPackages = [
      winapps-pkgs.winapps
      winapps-pkgs.winapps-launcher
      pkgs.dialog
      pkgs.freerdp3
      pkgs.iproute2
      pkgs.libnotify
      pkgs.netcat-gnu
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
  };
}
