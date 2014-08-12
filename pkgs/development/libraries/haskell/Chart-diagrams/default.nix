# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, blazeSvg, Chart, colour, dataDefaultClass, diagramsCore
, diagramsLib, diagramsPostscript, diagramsSvg, lens, mtl
, operational, SVGFonts, text, time
}:

cabal.mkDerivation (self: {
  pname = "Chart-diagrams";
  version = "1.2.4";
  sha256 = "099frqvfjqqc7h3zr52saqyg37di0klr0y649afzxd7lj3d67mvw";
  buildDepends = [
    blazeSvg Chart colour dataDefaultClass diagramsCore diagramsLib
    diagramsPostscript diagramsSvg lens mtl operational SVGFonts text
    time
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/timbod7/haskell-chart/wiki";
    description = "Diagrams backend for Charts";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
