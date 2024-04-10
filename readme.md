# NixOS Configuration

# Programs

Configurations for programs contained in either `modules/home/programs` or `modules/nixos/programs`.

## Desktop
Need to add `modules/home/programs/desktop` to `imports`.
### **Programs enabled by default:**

* firefox
* vscode
* kalc
* vlc

### **Optional Programs:**

### Betterbird

Add to `home.nix`:
```
betterbird.enable = true;
```
### Bitwarden

Add to home.nix:
```
bitwarden.enable = true;
```
### Chrome

Add to home.nix:
```
chrome.enable = true;
```
### Discord

Add to home.nix:
```
discord.enable = true;
```
### Filezilla

Add to home.nix:
```
filezilla.enable = true;
```
### Libre Office

Add to home.nix:
```
libreoffice.enable = true;
```
### Onedrive

Add to home.nix:
```
onedrive.enable = true;
```
### Solaar

Add to home.nix:
```
solaar.enable = true;
```
### Spotify

Add to home.nix:
```
spotify = {
    enable = true;
    theme = "THEME_NAME"
}
```
Theme Names:
* "nord"
* "dark-blue"

### Wine (This home-manager version might not work)

Add to home.nix:
```
wine.enable = true;
```


## CLI
Need to add `modules/home/programs/cli` to `imports`.
### **Programs enabled by default:**

* git
* wget
* tree

### **Optional Programs:**

### Wireguard

Add to home.nix:
```
wireguard.enable = true;
```
