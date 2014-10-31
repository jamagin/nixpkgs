{ stdenv, fetchurl, fetchgit, fetchFromGitHub
, zlib, zlibSupport ? true
, openssl, opensslSupport ? true
, gdbm, gdbmSupport ? true
, ncurses, readline, cursesSupport ? false
, groff, docSupport ? false
, libyaml, yamlSupport ? true
, libffi, fiddleSupport ? true
, ruby_2_1_0, autoreconfHook, bison, useRailsExpress ? true
}:

let
  op = stdenv.lib.optional;
  ops = stdenv.lib.optionals;
  patchSet = import ./rvm-patchsets.nix { inherit fetchFromGitHub; };
  config = import ./config.nix fetchgit;
  baseruby = ruby_2_1_0.override { useRailsExpress = false; };
in

stdenv.mkDerivation rec {
  version = with passthru; "${majorVersion}.${minorVersion}.${teenyVersion}-p${patchLevel}";

  name = "ruby-${version}";

  src = if useRailsExpress then fetchFromGitHub {
    owner  = "ruby";
    repo   = "ruby";
    rev    = "v2_1_0";
    sha256 = "12sn532yvznqfz85378ys0b9ggmj7w8ddhzc1pnnlx7mbyy7r2hx";
  } else fetchurl {
    url = "http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.0.tar.gz";
    sha256 = "17fhfbw8sr13rxfn58wvrhk2f5i88lkna2afn3gdjvprd8gyqf1m";
  };

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  NROFF = "${groff}/bin/nroff";

  buildInputs = ops useRailsExpress [ autoreconfHook bison ]
    ++ (op fiddleSupport libffi)
    ++ (ops cursesSupport [ ncurses readline ] )
    ++ (op docSupport groff )
    ++ (op zlibSupport zlib)
    ++ (op opensslSupport openssl)
    ++ (op gdbmSupport gdbm)
    ++ (op yamlSupport libyaml)
    # Looks like ruby fails to build on darwin without readline even if curses
    # support is not enabled, so add readline to the build inputs if curses
    # support is disabled (if it's enabled, we already have it) and we're
    # running on darwin
    ++ (op (!cursesSupport && stdenv.isDarwin) readline);

  enableParallelBuilding = true;

  # Fix a build failure on systems with nix store optimisation.
  # (The build process attempted to copy file a overwriting file b, where a and
  # b are hard-linked, which results in cp returning a non-zero exit code.)
  # https://github.com/NixOS/nixpkgs/issues/4266
  postUnpack = ''rm "$sourceRoot/enc/unicode/name2ctype.h"'';

  patches = ops useRailsExpress [
    "${patchSet}/patches/ruby/2.1.0/railsexpress/01-current-2.1.1-fixes.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/02-zero-broken-tests.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/03-improve-gc-stats.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/04-display-more-detailed-stack-trace.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/05-show-full-backtrace-on-stack-overflow.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/06-fix-missing-c-return-event.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/07-backport-006e66b6680f60adfb434ee7397f0dbc77de7873.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/08-funny-falcon-stc-density.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/09-funny-falcon-stc-pool-allocation.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/10-aman-opt-aset-aref-str.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/11-funny-falcon-method-cache.patch"
    "${patchSet}/patches/ruby/2.1.0/railsexpress/12-backport-r44370.patch"
  ];

  # Ruby >= 2.1.0 tries to download config.{guess,sub}
  postPatch = ''
    rm tool/config_files.rb
    cp ${config}/config.guess tool/
    cp ${config}/config.sub tool/
  '';

  configureFlags = ["--enable-shared" ]
    ++ op useRailsExpress "--with-baseruby=${baseruby}/bin/ruby"
    # on darwin, we have /usr/include/tk.h -- so the configure script detects
    # that tk is installed
    ++ ( if stdenv.isDarwin then [ "--with-out-ext=tk " ] else [ ]);

  installFlags = stdenv.lib.optionalString docSupport "install-doc";
  # Bundler tries to create this directory
  postInstall = ''
    # Bundler tries to create this directory
    mkdir -pv $out/${passthru.gemPath}
    mkdir -p $out/nix-support
    cat > $out/nix-support/setup-hook <<EOF
    addGemPath() {
      addToSearchPath GEM_PATH \$1/${passthru.gemPath}
    }

    envHooks+=(addGemPath)
    EOF
  '';

  meta = {
    license = "Ruby";
    homepage = "http://www.ruby-lang.org/en/";
    description = "The Ruby language";
    platforms = stdenv.lib.platforms.all;
  };

  passthru = rec {
    majorVersion = "2";
    minorVersion = "1";
    teenyVersion = "0";
    patchLevel = "0";
    libPath = "lib/ruby/${majorVersion}.${minorVersion}";
    gemPath = "lib/ruby/gems/${majorVersion}.${minorVersion}";
  };
}
