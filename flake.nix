{
  description = "A development environment as a Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [ ];
        };
      requiredTools =
        pkgs: with pkgs; [
          cmake
          copier
          dtc
          just
          python3
          python3Packages.west
        ];
    in
    {
      devShells = forAllSystems (system: {
        default =
          let
            pkgs = mkPkgs system;
          in
          pkgs.mkShell {
            packages = requiredTools pkgs;

            shellHook = ''
              echo "Starting development environment..."
            '';
          };
      });

      apps = forAllSystems (system: {
        default =
          let
            pkgs = mkPkgs system;
            package = pkgs.writeShellApplication {
              name = "run-copier";

              runtimeInputs = requiredTools pkgs;

              text = ''
                copier "$@"
              '';
            };
          in
          {
            type = "app";
            program = "${package}/bin/run-copier";
          };
      });
    };
}
