{
  config,
  lib,
  pkgs,
  system,
  inputs,
  ...
}: {
  imports = [
    ../../modules/home/configuration
    ../../modules/home/programs/cli
    ../../modules/home/programs/desktop
  ];

  nix.settings = {
    warn-dirty = false;
  };

  # TODO: Do this only on the hyprland specialisation
  hyprland-conf = {
    enable = true;
    monitor = [
      "DP-2,2560x1080@144,0x0,1" # Main Ultrawide
      "HDMI-A-1,2560x1080@60,0x-1080,1" #Top Ultrawide
      "HDMI-A-2,1920x1080@60,-1080x-840,1,transform,1" #Left Vertical
      "DP-1,1920x1080@60,2560x-700,1,transform,1" #Right Vertical
    ];
    extraBind = [
      "Super, P, split:swapactiveworkspaces, 0 3"
    ];
    extraWindowrulev2 = [
      # "monitor 2,title:(Spotify Premium)"
      # "monitor 2,class:(discord)" # Discord native app
      # "monitor 2,title:^(Discord)" # Discord PWA
    ];
    mouse.sensitivity = -0.6;
    wallpaper = "~/nix-configuration/wallpapers/black-sand-1.png";
  };

  spotify = {
    enable = true;
    theme = "dark-blue";
  };

  stylix = {
    autoEnable = false;
    targets = {
      # vscode.enable = false;
      # spicetify.enable = false;
      # firefox.enable = false;
      kitty.enable = true;
    };
  };

  git.enable = true;

  betterbird.enable = true;
  bitwarden.enable = true;
  chrome.enable = true;
  discord.enable = true;
  filezilla.enable = true;
  msteams.enable = true;
  solaar.enable = true;
  onedrive.enable = true;
  wireguard.enable = true;

  obs.enable = true;
  zoom.enable = true;

  firefox.installPWA = true;

  xbindkeys.enable = true;

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   package = pkgs.hyprland;
  #   systemd.enable = true;
  # };

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
    devenv
    parsec-bin
    gamescope
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
