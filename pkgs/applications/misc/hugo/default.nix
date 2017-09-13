{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.27";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "1r64pwk5g50gwriawmsgza6j8m4jymg8mwgwh1rplpsdfxqdfrbx";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
