{
  config,
  pkgs,
  ...
}: {
  # pkgs.firefox = {
  #   extraNativeMessagingHosts = [
  #     pkgs.firefoxpwa
  #   ];
  # };

  home.packages = with pkgs; [
    firefox
    firefoxpwa
  ];

  programs.firefox.nativeMessagingHosts = [pkgs.firefoxpwa];
}
