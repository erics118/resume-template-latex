{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, config, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages =
              with pkgs;
              [
                (texliveSmall.withPackages (
                  ps: with ps; [
                    academicons
                    accsupp
                    adjustbox
                    caption
                    charter
                    cm-super
                    csquotes
                    oberdiek
                    enumitem
                    fancyhdr
                    float
                    fontawesome5
                    jknapltx
                    lastpage
                    latexindent
                    latexmk
                    libertine
                    mdframed
                    microtype
                    multirow
                    parskip
                    pgf
                    ragged2e
                    relsize
                    tcolorbox
                    tikz-cd
                    titlesec
                    ulem
                    xcolor
                  ]
                ))
                texlab
                just
                # renders a pdf to png, and reads a pdf's text and page count
                ghostscript
                poppler-utils
                perl
                perlPackages.FileHomeDir
                perlPackages.UnicodeLineBreak
                perlPackages.YAMLTiny
                perlPackages.LogLog4perl
                perlPackages.LogDispatch
              ];
            # SOURCE_DATE_EPOCH fixes the pdf's embedded dates so rebuilds are byte-identical
            shellHook = ''
              export SOURCE_DATE_EPOCH=0
            '';
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              just.enable = true;
              latexindent.enable = true;
              yamlfmt.enable = true;
            };
            settings.formatter.latexindent.options = [
              "-l=localSettings.yaml"
            ];
            settings.formatter.yamlfmt.options = [
              "-formatter"
              "retain_line_breaks_single=true"
            ];
          };

          formatter = config.treefmt.build.wrapper;
        };
    };
}
