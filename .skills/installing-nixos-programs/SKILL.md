---
name: installing-nixos-programs
description: Installs programs on NixOS by creating home-manager module files with enable options, adding them to imports, and enabling them by default. Use when the user asks to install, add, or set up an application or program on a NixOS system.
---

# Installing NixOS Programs

Installs programs on NixOS using the home-manager module pattern.

## When to Use

Use this skill when the user asks to:
- "Install [program]"
- "Add [program] to my system"
- "I want to install [program]"
- "Can you install [program] for me?"

## Workflow

1. **Find the package**: Search nixpkgs for the package name matching the program
2. **Determine location**: CLI tools go in `cli/`, GUI apps go in `desktop/`
3. **Check config location**: Default is `~/nix-configuration`. If different, check `system/nixos.md` for known patterns or ask user and record the pattern
4. **Create the program file**: Create `<program>.nix` in the appropriate directory using the template
5. **Add to imports**: Add `./<program>.nix` to the imports list in `default.nix`
6. **Enable by default**: Add `<program>.enable = lib.mkDefault true;` below the imports
7. **Rebuild**: Run `rb -h` to verify the config builds successfully

## Config Location

Standard location: `~/nix-configuration/modules/home/programs/`

For non-standard configs, check memory for known patterns. If unknown:
1. Ask the user where programs are installed
2. Record the pattern in `system/nixos.md` under "Machine Config Locations"
3. Proceed with installation

## Template

See [references/template.nix](references/template.nix) for the base module format.

## Example: Installing htop (CLI)

1. Package found: `htop` in nixpkgs
2. Location: `~/nix-configuration/modules/home/programs/cli/htop.nix`
3. Create file:
   ```nix
   {
     config,
     lib,
     pkgs,
     ...
   }:
   with lib; {
     options = {
       htop.enable = mkEnableOption "Enable htop";
     };

     config = mkIf config.htop.enable {
       home.packages = with pkgs; [
         htop
       ];
     };
   }
   ```
4. Add `./htop.nix` to imports in `cli/default.nix`
5. Add `htop.enable = lib.mkDefault true;` below imports
6. Run `rb -h` to verify

## Example: Installing discord (GUI)

1. Package found: `discord` in nixpkgs
2. Location: `~/nix-configuration/modules/home/programs/desktop/discord.nix`
3. Create file with same pattern
4. Add to `desktop/default.nix` imports and enable line
5. Run `rb -h` to verify
