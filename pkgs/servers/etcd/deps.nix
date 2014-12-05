# This file was generated by go2nix.
{ stdenv, lib, fetchFromGitHub }:

let
  goDeps = [
    {
      root = "github.com/coreos/etcd";
      src = fetchFromGitHub {
        owner = "coreos";
        repo = "etcd";
        rev = "d01d6119e54f729f54e9776ad5729277fcf38668";
        sha256 = "0h9d6rc8yx7vyv2ggvzsddyng03pjhyb7avm9wrc805qr7p8nhns";
      };
    }
  ];

in

stdenv.mkDerivation rec {
  name = "go-deps";

  buildCommand =
    lib.concatStrings
      (map (dep: ''
              mkdir -p $out/src/`dirname ${dep.root}`
              ln -s ${dep.src} $out/src/${dep.root}
            '') goDeps);
}
