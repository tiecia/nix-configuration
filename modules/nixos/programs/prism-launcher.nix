{
  config,
  pkgs,
  ...
}: {
  pkgs.config = {
    permittedInsecurePackages = [
      "freeimage-unstable-2021-11-01"
    ];
  };

  environment.systemPackages = with pkgs; [
    megasync # TODO: Automate file sync
    prismlauncher
  ];

  #   nixpkgs.config.permittedInsecurePackages = [
  #     "freeimage-unstable-2021-11-01"
  #   ];
}
