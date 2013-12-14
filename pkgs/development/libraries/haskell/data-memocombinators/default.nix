{ cabal, dataInttrie }:

cabal.mkDerivation (self: {
  pname = "data-memocombinators";
  version = "0.5.1";
  sha256 = "1mvfc1xri3kgkx5q7za01bqg1x3bfvbgcffw5vwl6jmq4hh1sd5l";
  buildDepends = [ dataInttrie ];
  meta = {
    homepage = "http://github.com/luqui/data-memocombinators";
    description = "Combinators for building memo tables";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
