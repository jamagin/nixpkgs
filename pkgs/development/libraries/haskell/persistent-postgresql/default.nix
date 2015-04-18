# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, aeson, blazeBuilder, conduit, monadControl, monadLogger
, persistent, postgresqlLibpq, postgresqlSimple, resourcet, text
, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "persistent-postgresql";
  version = "2.1.1";
  sha256 = "0mfvzd62qn7ffx6nrgkr52qzl3prjq8xkahvb6j5akb6azdmzg80";
  buildDepends = [
    aeson blazeBuilder conduit monadControl monadLogger persistent
    postgresqlLibpq postgresqlSimple resourcet text time transformers
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Backend for the persistent library using postgresql";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
