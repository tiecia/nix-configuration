# NixOS Configuration

# Programs

Configurations for programs contained in either `modules/home/programs` or `modules/nixos/programs/`.

## Desktop

## CLI
Configurations contained in  `modules/home/programs/cli`.
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
