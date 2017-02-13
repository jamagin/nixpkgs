{ stdenv, R, makeWrapper, recommendedPackages, packages }:

stdenv.mkDerivation rec {
  name = R.name + "-wrapper";

  buildInputs = [makeWrapper R] ++ recommendedPackages ++ packages;

  unpackPhase = ":";

  # This filename is used in 'installPhase', but needs to be
  # referenced elsewhere.  This will be relative to this package's
  # path.
  passthru = {
    fixLibsR = "fix_libs.R";
  };
  
  installPhase = ''
    mkdir -p $out/bin
    cd ${R}/bin
    for exe in *; do
      makeWrapper ${R}/bin/$exe $out/bin/$exe \
        --prefix "R_LIBS_SITE" ":" "$R_LIBS_SITE"
    done
    # RStudio (and perhaps other packages) overrides the R_LIBS_SITE
    # which the wrapper above applies, and as a result packages
    # installed in the wrapper (as in the method described in
    # https://nixos.org/nixpkgs/manual/#r-packages) aren't visible.
    # The below turns R_LIBS_SITE into some R startup code which can
    # correct this.
    echo "# Autogenerated by wrapper.nix from R_LIBS_SITE" > $out/${passthru.fixLibsR}
    echo -n ".libPaths(c(.libPaths(), \"" >> $out/${passthru.fixLibsR}
    echo -n $R_LIBS_SITE | sed -e 's/:/", "/g' >> $out/${passthru.fixLibsR}
    echo -n "\"))" >> $out/${passthru.fixLibsR}
    echo >> $out/${passthru.fixLibsR}
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
