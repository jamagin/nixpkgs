{ cabal, hxtCharproperties }:

cabal.mkDerivation (self: {
  pname = "hxt-unicode";
  version = "9.0.2.2";
  sha256 = "1iljbk7f7d4wkl592bp0vw807683sqdxfnigindkrvr9p1xvwg8r";
  buildDepends = [ hxtCharproperties ];
  meta = {
    homepage = "http://www.fh-wedel.de/~si/HXmlToolbox/index.html";
    description = "Unicode en-/decoding functions for utf8, iso-latin-* and other encodings";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
