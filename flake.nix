{
  description = "LaTeX development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            (texlive.combine {
              inherit (texlive) scheme-full;
            })
            texlab
            perl
            perlPackages.FileHomeDir
            perlPackages.UnicodeLineBreak
            perlPackages.YAMLTiny
            perlPackages.LogLog4perl
            perlPackages.LogDispatch
          ];
        };
      }
    );
}
