# This file was generated by go2nix.
{ stdenv, lib, go16Packages, fetchgit, fetchhg, fetchbzr, fetchsvn }:

with go16Packages;

buildGoPackage rec {
  name = "consul-template-${version}";
  version = "0.14.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/consul-template";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/hashicorp/consul-template";
    sha256 = "15zsax44g3dwjmmm4fpb54mvsjvjf3b6g3ijskgipvhcy0d3j938";
  };
}
