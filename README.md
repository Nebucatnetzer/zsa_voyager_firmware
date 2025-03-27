# zsa_voyager_firmware

This repository lets you build the firmware for the ZSA Voyager.

## Requirements

- Nix
- Direnv (Only for development)

## How To

1. Configure the keyboard like you normally would through Oryx.
2. Update the source with `nix develop --command update-source FIRMWARE_ID`
   where FIRMWARE_ID is the ID of the current Oryx version. E.g. if the URL is
   built like this: `https://configure.zsa.io/voyager/layouts/aZXp3/jZZQr4/0`
   The ID of the current build is after the second slash after "layouts".l
   Meaning `jZZQr4`
3. Make additional changes to the source code.
4. Update the firmware with `nix develop --command build-firmware`.
5. Optionally commit the changes of the source.
