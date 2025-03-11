{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home/configuration
    ../../modules/home/programs/cli
    ../../modules/home/programs/desktop
  ];

  # TODO: Do this only in hyprland specialisation
  hyprland-conf = {
    enable = true;
    laptop = true;
    monitor = ",2400x1600@120,0x0,1";
    wallpaper = "~/nix-configuration/wallpapers/cloud-binary-0-1-rain.jpg";
  };

  spotify = {
    enable = true;
    # theme = "nord";
  };

  git.enable = true;
  wireguard.enable = true;

  betterbird.enable = true;
  bitwarden.enable = true;
  chrome.enable = true;
  discord.enable = true;
  filezilla.enable = true;
  msteams.enable = true;
  solaar.enable = true;
  onedrive.enable = true;

  firefox.installPWA = true;

  xbindkeys.enable = true;

  # wayland.windowManager.hyprland = {
  #   enable = true;
  # };

  # This is where we can configure programs differently for this host.
  programs = {
    home-manager.enable = true;
    # kitty = {
    #   enable = true; # Kitty is installed by Hyprland so we need to enable it here for options.
    #   font = {
    #     size = lib.mkForce 17;
    #   };
    # };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tiec";
  home.homeDirectory = "/home/tiec";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Install packages globally in the user profile.
  home.packages = with pkgs; [
    # hello
    parsec-bin
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".config/onedrive/accounts/Personal/sync_list".source = pkgs.writeTextFile {
    #   name = "sync_list";
    #   text = ''
    #     !/Documents/2008 Nordhavn 64 PERSEVERANCE
    #     !/Documents/Backups

    #     /Documents'';
    # };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/tiec/etc/profile.d/hm-session-vars.sh
  #

  # Add environment variables to the shell environment.
  home.sessionVariables = {
    # # This will add the 'MY_ENV_VAR' environment variable to your shell
    # # environment.
    # MY_ENV_VAR = "some value";
  };
}
