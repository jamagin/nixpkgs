{ cabal, blazeHtml, htmlConduit, parsec, QuickCheck, text, thLift
, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "dom-selector";
  version = "0.2.0.1";
  sha256 = "1nm3r79k4is5lh5fna4v710vhb0n5hpp3d21r0w6hmqizhdrkb22";
  buildDepends = [
    blazeHtml htmlConduit parsec QuickCheck text thLift xmlConduit
  ];
  testDepends = [
    blazeHtml htmlConduit parsec QuickCheck text thLift xmlConduit
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/nebuta/";
    description = "DOM traversal by CSS selectors for xml-conduit package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
