# This file was auto-generated by cabal2nix. Please do NOT edit manually!

{ cabal, exceptions, mtl, network, networkUri, parsec, xhtml }:

cabal.mkDerivation (self: {
  pname = "cgi";
  version = "3001.2.0.0";
  sha256 = "03az978d5ayv5v4g89h4wajjhcribyf37b8ws8kvsqir3i7h7k8d";
  buildDepends = [ exceptions mtl network networkUri parsec xhtml ];
  meta = {
    homepage = "https://github.com/cheecheeo/haskell-cgi";
    description = "A library for writing CGI programs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
