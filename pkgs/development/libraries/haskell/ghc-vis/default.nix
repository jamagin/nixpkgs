# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, cairo, deepseq, fgl, ghcHeapView, graphviz, gtk, mtl
, svgcairo, text, transformers, xdot
}:

cabal.mkDerivation (self: {
  pname = "ghc-vis";
  version = "0.7.2.7";
  sha256 = "0kxkmbp71yx5mskzpcyjd8s2yq01q1q6dxmqzmwg6naalcpcbswv";
  buildDepends = [
    cairo deepseq fgl ghcHeapView graphviz gtk mtl svgcairo text
    transformers xdot
  ];
  postInstall = ''
    ensureDir "$out/share/ghci"
    ln -s "$out/share/$pname-$version/ghci" "$out/share/ghci/$pname"
  '';
  meta = {
    homepage = "http://felsin9.de/nnis/ghc-vis";
    description = "Live visualization of data structures in GHCi";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = with self.stdenv.lib.maintainers; [ andres ];
  };
})
