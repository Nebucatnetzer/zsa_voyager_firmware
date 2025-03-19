{
  description = "A flake to create a firmware for my ZSA Voyager.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
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
    in
    {
      devShells."${system}".default = pkgs.mkShellNoCC {
        packages = [
          pkgs.keymapp
          pkgs.qmk
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
