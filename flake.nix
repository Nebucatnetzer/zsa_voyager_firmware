{
  description = "A flake to create a firmware for my ZSA Voyager.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    zsa.url = "github:zsa/qmk_firmware/firmware24";
    zsa.flake = false;
  };

  outputs =
    { ... }@inputs:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      system = "x86_64-linux";
      update-source = pkgs.writeShellApplication {
        name = "update-source";
        runtimeInputs = [
          pkgs.curl
        ];
        text = builtins.readFile ./update_source.sh;
      };
      build-firmware = pkgs.writeShellApplication {
        name = "build-firmware";
        runtimeInputs = [
          pkgs.curl
        ];
        text = builtins.readFile ./build_firmware.sh;
      };
      qmkFirmware = pkgs.fetchFromGitHub {
        name = "zsa-firmware-${inputs.zsa.rev}-source";
        owner = "zsa";
        repo = "qmk_firmware";
        inherit (inputs.zsa) rev;
        fetchSubmodules = true;
        sha256 = "sha256-J0lKc7bmwzwrKUx6q5CGZFTM4a1xvqgyCnpxBa9nFbI=";
      };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = [
          pkgs.avrdude
          pkgs.dfu-programmer
          pkgs.dfu-util
          pkgs.gcc-arm-embedded
          pkgs.keymapp
          pkgs.pkgsCross.avr.buildPackages.gcc8
          pkgs.qmk
          pkgs.rsync
          pkgs.shellcheck
          pkgs.shfmt
          build-firmware
          update-source
        ];
        shellHook = ''
          DEVENV_ROOT="$PWD"
          export DEVENV_ROOT
          QMK_FIRMWARE=${qmkFirmware}
          export QMK_FIRMWARE
        '';
      };
    };
}
