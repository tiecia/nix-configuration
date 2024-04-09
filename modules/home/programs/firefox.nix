{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    firefox
  ];

  # programs.firefox.nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
}
