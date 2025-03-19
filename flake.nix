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
      firmware = pkgs.callPackage ./firmware { zsa = inputs.zsa; };
    in
    {
      packages."${system}".default = firmware;
      devShells."${system}".default = pkgs.mkShell {
        packages = [
          pkgs.keymapp
          pkgs.shellcheck
          pkgs.shfmt
          update-source
        ];
        shellHook = ''
          DEVENV_ROOT="$PWD"
          export DEVENV_ROOT
        '';
      };
    };
}
