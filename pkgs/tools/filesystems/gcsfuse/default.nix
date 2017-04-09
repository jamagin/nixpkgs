# This file was generated by go2nix.
{ lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "gcsfuse-${version}";
  version = "v0.19.0";
  rev = "81281027c0093e3f916a6e611a128ec5c3a12ece";

  goPackagePath = "github.com/googlecloudplatform/gcsfuse";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/googlecloudplatform/gcsfuse";
    sha256 = "1lj9czippsgkhr8y3r7vwxgc8i952v76v1shdv10p43gsxwyyi9a";
  };

  meta = {
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [];
    homepage = https://cloud.google.com/storage/docs/gcs-fuse;
    description =
      "A user-space file system for interacting with Google Cloud Storage";
  };
}
