# zsa_voyager_firmware

This repository lets you build the firmware for the ZSA Voyager.

## Requirements

- Nix
- Direnv (Only for development)

## How To

1. Configure the keyboard like you normally would through Oryx.
2. Update the source with `nix develop --command update-source`.
3. Make additional changes to the source code.
4. Build the source with `nix build`.
5. Optionally commit the changes of the source.
