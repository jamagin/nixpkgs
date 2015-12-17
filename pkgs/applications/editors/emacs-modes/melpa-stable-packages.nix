pkgs: with pkgs;

let

  inherit (stdenv.lib) makeScope mapAttrs;

  json = builtins.readFile ./melpa-stable-packages.json;
  manifest = builtins.fromJSON json;

  mkPackage = self: name: recipe:
    let drv =
          { melpaBuild, stdenv, fetchurl, fetchcvs, fetchgit, fetchhg }:
          let
            unknownFetcher =
              abort "emacs-${name}: unknown fetcher '${recipe.fetch.tag}'";
            fetch =
              {
                inherit fetchurl fetchcvs fetchgit fetchhg;
              }."${recipe.fetch.tag}"
              or unknownFetcher;
            args = builtins.removeAttrs recipe.fetch [ "tag" ];
            src = fetch args;
          in melpaBuild {
            pname = name;
            inherit (recipe) version;
            inherit src;
            deps =
              let lookupDep = d: self."${d}" or null;
              in map lookupDep recipe.deps;
            meta = {
              homepage = "http://stable.melpa.org/#/${name}";
              license = stdenv.lib.licenses.free;
            };
          };
    in self.callPackage drv {};

in

self:

  let
    super = mapAttrs (mkPackage self) manifest;

    markBroken = pkg: pkg.override {
      melpaBuild = args: self.melpaBuild (args // {
        meta = (args.meta or {}) // { broken = true; };
      });
    };
  in
    super // { melpaStablePackages = super; }
