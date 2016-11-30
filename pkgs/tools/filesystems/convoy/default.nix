# This file was generated by go2nix.
{ stdenv, buildGoPackage, fetchFromGitHub, devicemapper }:

buildGoPackage rec {
  name = "convoy-${version}";
  version = "0.5.0";

  goPackagePath = "github.com/rancher/convoy";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "rancher";
    repo = "convoy";
    sha256 = "0ihy0cfq7sa2wml904ajwr165hx2mas3jb1bqk3i0m4fg1lx1xw1";
  };

  buildInputs = [devicemapper];

  meta = with stdenv.lib; {
    homepage = https://github.com/rancher/convoy;
    description = "A Docker volume plugin, managing persistent container volumes.";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
}
