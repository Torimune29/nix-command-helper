{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      pre-commit = import ./tools/pre-commit {inherit system pre-commit-hooks;};
      defaultCommands = import ./tools/commands {inherit pkgs;};
      commandHelper = import ./tools/command-helper;
    in {
      checks = {
        build = self.packages.${system}.default;
        pre-commit-check = pre-commit;
      };
      # `nix develop`
      devShells.default = commandHelper {
        inherit pkgs;
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        shell = "mkShellNoCC";
        commands =
          defaultCommands
          /*
          ++ customCommands
          */
          ;
        nativeBuildInputs = with pkgs; [
          tree
          commitizen
        ];
      };
    });
}
