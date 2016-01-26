{ pkgs, pkgsi686Linux }:

let
  callPackage = pkgs.newScope self;
  callPackage_i686 = pkgsi686Linux.newScope self;

  self = {
    dwarf-fortress-original = callPackage_i686 ./game.nix { };

    dfhack = callPackage_i686 ./dfhack {
      inherit (pkgsi686Linux.perlPackages) XMLLibXML XMLLibXSLT;
    };

    dwarf-fortress-unfuck = callPackage_i686 ./unfuck.nix { };

    dwarf-fortress = callPackage ./wrapper { };

    dwarf-therapist-original = callPackage ./dwarf-therapist {
      texlive = pkgs.texlive.combine {
        inherit (pkgs.texlive) scheme-basic float caption wrapfig adjmulticol sidecap preprint enumitem;
      };
    };

    dwarf-therapist = callPackage ./dwarf-therapist/wrapper.nix { };
  };

in self
