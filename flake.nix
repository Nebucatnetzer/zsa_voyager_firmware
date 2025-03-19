{
  description = "A flake to create a firmware for my ZSA Voyager.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs =
    { ... }@inputs:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default = pkgs.mkShellNoCC {
        packages = [
          pkgs.keymapp
          pkgs.qmk
        ];
        shellHook = ''
          DEVENV_ROOT="$PWD"
          export DEVENV_ROOT
        '';
      };
    };
}
