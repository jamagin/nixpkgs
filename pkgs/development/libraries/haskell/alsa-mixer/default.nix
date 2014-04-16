{ cabal, alsaCore, alsaLib, c2hs }:

cabal.mkDerivation (self: {
  pname = "alsa-mixer";
  version = "0.2.0.2";
  sha256 = "11sc2n879a8rb9yz54cb8vg8rplgapbymzy785p7n7638xx877hk";
  buildDepends = [ alsaCore ];
  buildTools = [ c2hs ];
  extraLibraries = [ alsaLib ];
  meta = {
    homepage = "https://github.com/ttuegel/alsa-mixer";
    description = "Bindings to the ALSA simple mixer API";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = with self.stdenv.lib.maintainers; [ ttuegel ];
  };
})
