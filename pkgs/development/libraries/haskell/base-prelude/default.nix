# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal }:

cabal.mkDerivation (self: {
  pname = "base-prelude";
  version = "0.1.6";
  sha256 = "1lc8j3wfaqh42pqshlizkpr67ghkr1m90m1g9xiw8h36p8n72fcm";
  meta = {
    homepage = "https://github.com/nikita-volkov/base-prelude";
    description = "The most complete prelude formed from only the \"base\" package";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
