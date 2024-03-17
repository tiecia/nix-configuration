
{ config, pkgs, ... }:

{
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim
        wget
        vscode
        spotify
        git
	python3
	python311Packages.pytest
    ];


}
 
