{ cabal, active, colour, dataDefaultClass, diagramsCore, filepath
, fingertree, hashable, intervals, lens, MemoTrie, monoidExtras
, optparseApplicative, safe, semigroups, tagged, vectorSpace
, vectorSpacePoints
}:

cabal.mkDerivation (self: {
  pname = "diagrams-lib";
  version = "1.1.0.6";
  sha256 = "125krfaf73k2m73scnjdl0d76acwc6n9vhvvaqxxy1ln57caqh5x";
  buildDepends = [
    active colour dataDefaultClass diagramsCore filepath fingertree
    hashable intervals lens MemoTrie monoidExtras optparseApplicative
    safe semigroups tagged vectorSpace vectorSpacePoints
  ];
  jailbreak = true;
  meta = {
    homepage = "http://projects.haskell.org/diagrams";
    description = "Embedded domain-specific language for declarative graphics";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
