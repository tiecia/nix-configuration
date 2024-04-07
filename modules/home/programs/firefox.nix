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
  ];

  programs.firefox.nativeMessagingHosts = [pkgs.firefoxpwa];
}
