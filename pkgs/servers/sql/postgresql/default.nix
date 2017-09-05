{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, libxml2, makeWrapper }:

let

  common = { version, sha256, psqlSchema } @ args:
   let atLeast = lib.versionAtLeast version; in stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl libxml2 makeWrapper ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
    ]
      ++ lib.optional (stdenv.isDarwin)  "--with-uuid=e2fs"
      ++ lib.optional (!stdenv.isDarwin) "--with-ossp-uuid";

    patches =
      [ (if atLeast "9.4" then ./disable-resolve_symlinks-94.patch else ./disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./less-is-more-96.patch             else ./less-is-more.patch)
        (if atLeast "9.6" then ./hardcode-pgxs-path-96.patch       else ./hardcode-pgxs-path.patch)
        ./specify_pkglibdir_at_runtime.patch
      ];

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postConfigure =
      let path = if atLeast "9.6" then "src/common/config_info.c" else "src/bin/pg_config/pg_config.c"; in
        ''
          # Hardcode the path to pgxs so pg_config returns the path in $out
          substituteInPlace "${path}" --replace HARDCODED_PGXS_PATH $out/lib
        '';

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        # Remove static libraries in case dynamic are available.
        for i in $out/lib/*.a; do
          name="$(basename "$i")"
          if [ -e "$lib/lib/''${name%.a}.so" ] || [ -e "''${i%.a}.so" ]; then
            rm "$i"
          fi
        done
      '';

    postFixup = lib.optionalString (!stdenv.isDarwin)
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema;
    };

    meta = with lib; {
      homepage = https://www.postgresql.org;
      description = "A powerful, open source object-relational database system";
      license = licenses.postgresql;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
      hydraPlatforms = platforms.linux;
    };
  });

in {

  postgresql93 = common {
    version = "9.3.19";
    psqlSchema = "9.3";
    sha256 = "1d9gmi1psg4aa6h6ylvsrdm5jnnb7p36pn4h2qrvl9z9v4n8g7pv";
  };

  postgresql94 = common {
    version = "9.4.14";
    psqlSchema = "9.4";
    sha256 = "0szc0navrcjnpyafw2sai8cmwr3znsy0w6031lv7n1ab20xg4zcf";
  };

  postgresql95 = common {
    version = "9.5.7";
    psqlSchema = "9.5";
    sha256 = "8b1e936f82109325decc0f5575e846b93fb4fd384e8c4bde83ff5e7f87fc6cad";
  };

  postgresql96 = common {
    version = "9.6.3";
    psqlSchema = "9.6";
    sha256 = "1645b3736901f6d854e695a937389e68ff2066ce0cde9d73919d6ab7c995b9c6";
  };

}
