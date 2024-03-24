{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    megasync # TODO: Automate file sync
    prismlauncher
  ];

  # pkgs.config.permittedInsecurePackages = [
  #   "freeimage-unstable-2021-11-01"
  # ];
}
