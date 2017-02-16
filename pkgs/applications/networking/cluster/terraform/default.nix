{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "terraform-${version}";
  version = "0.8.7";

  goPackagePath = "github.com/hashicorp/terraform";

  src = fetchFromGitHub {
    owner  = "hashicorp";
    repo   = "terraform";
    rev    = "v${version}";
    sha256 = "0b30m0qc50x84klc8ggc3i83z36l46b1qmc8mpw90mxp07ra8vbw";
  };

  postInstall = ''
    # remove all plugins, they are part of the main binary now
    for i in $bin/bin/*; do
      if [[ $(basename $i) != terraform ]]; then
        rm "$i"
      fi
    done
  '';

  meta = with stdenv.lib; {
    description = "Tool for building, changing, and versioning infrastructure";
    homepage = "https://www.terraform.io/";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      jgeerds
      zimbatm
    ];
  };
}
