{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          python = pkgs.python3.withPackages (
            ps: with ps; [
              ipykernel
              matplotlib
              numpy
              pandas
              scikit-learn
              scipy
            ]
          );
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [ 
              python 
            ];
          };
        }
      );
    };
}
