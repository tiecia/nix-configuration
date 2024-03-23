{
  config,
  pkgs,
  ...
}: {
  environment = {
    shellAliases = {
      edit = "code ~/nix-configuration";
      rebuild = "~/nix-configuration/nixos-rebuild.sh";

      sconf = "nano ~/nix-configuration/hosts/${CONFIGURATION_HOST}/configuration.nix";
      hconf = "nano ~/nix-configuration/hosts/desktop2/home.nix";
      nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#desktop";
      nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#desktop";
    };
  };
}
