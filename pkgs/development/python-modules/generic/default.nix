/* This function provides a generic Python package builder.  It is
   intended to work with packages that use `setuptools'
   (http://pypi.python.org/pypi/setuptools/), which represents a large
   number of Python packages nowadays.  */

{ python, setuptools, wrapPython, lib, offlineDistutils, recursivePthLoader }:

{ name, namePrefix ? "python-"

, buildInputs ? []

, propagatedBuildInputs ? []

, # List of packages that should be added to the PYTHONPATH
  # environment variable in programs built by this function.  Packages
  # in the standard `propagatedBuildInputs' variable are also added.
  # The difference is that `pythonPath' is not propagated to the user
  # environment.  This is preferrable for programs because it doesn't
  # pollute the user environment.
  pythonPath ? []

, installCommand ?
    ''
      easy_install --always-unzip --prefix="$out" .
    ''
    
, preConfigure ? "true"

, buildPhase ? "true"

, doCheck ? true

, checkPhase ?
    ''
      runHook preCheck
      python setup.py test
      runHook postCheck
    ''

, preInstall ? ""
, postInstall ? ""

, ... } @ attrs:

# Keep extra attributes from ATTR, e.g., `patchPhase', etc.
python.stdenv.mkDerivation (attrs // {
  inherit doCheck buildPhase checkPhase;

  name = namePrefix + name;

  # checkPhase after installPhase to run tests on installed packages
  phases = "unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase";

  buildInputs = [ python wrapPython setuptools ] ++ buildInputs ++ pythonPath;

  pythonPath = [ setuptools ] ++ pythonPath;

  preConfigure = ''
    PYTHONPATH="${offlineDistutils}/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    ${preConfigure}
  '';

  installPhase = preInstall + ''
    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    echo "installing \`${name}' with \`easy_install'..."
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    ${installCommand}

    # A pth file might have been generated to load the package from
    # within its own site-packages, rename this package not to
    # collide with others.
    eapth="$out/lib/${python.libPrefix}"/site-packages/easy-install.pth
    if [ -e "$eapth" ]; then
        # move colliding easy_install.pth to specifically named one
        mv "$eapth" $(dirname "$eapth")/${name}.pth
    fi

    # Remove any site.py files generated by easy_install as these
    # cause collisions. If pth files are to be processed a
    # corresponding site.py needs to be included in the PYTHONPATH.
    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*

    ${postInstall}
  '';

  postFixup =
    ''
      wrapPythonPrograms

      # these should already be in $name.pth
      #createBuildInputsPth build-inputs "$buildInputStrings"
      for inputsfile in propagated-build-inputs propagated-build-native-inputs; do
        if test -e $out/nix-support/$inputsfile; then
            createBuildInputsPth $inputsfile "$(cat $out/nix-support/$inputsfile)"
        fi
      done
    '';
})
