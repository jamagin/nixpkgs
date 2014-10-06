/* This function provides a generic Python package builder.  It is
   intended to work with packages that use `distutils/setuptools'
   (http://pypi.python.org/pypi/setuptools/), which represents a large
   number of Python packages nowadays.  */

{ python, setuptools, unzip, wrapPython, lib, recursivePthLoader, distutils-cfg }:

{ name

# by default prefix `name` e.g. "python3.3-${name}"
, namePrefix ? python.libPrefix + "-"

, buildInputs ? []

# pass extra information to the distutils global configuration (think as global setup.cfg)
, distutilsExtraCfg ? ""

# propagate build dependencies so in case we have A -> B -> C,
# C can import propagated packages by A
, propagatedBuildInputs ? []

# passed to "python setup.py install"
, setupPyInstallFlags ? []

# passed to "python setup.py build"
, setupPyBuildFlags ? []

# enable tests by default
, doCheck ? true

# List of packages that should be added to the PYTHONPATH
# environment variable in programs built by this function.  Packages
# in the standard `propagatedBuildInputs' variable are also added.
# The difference is that `pythonPath' is not propagated to the user
# environment.  This is preferrable for programs because it doesn't
# pollute the user environment.
, pythonPath ? []

# used to disable derivation, useful for specific python versions
, disabled ? false

, meta ? {}

# Execute before shell hook
, preShellHook ? ""

# Execute after shell hook
, postShellHook ? ""

, ... } @ attrs:


# Keep extra attributes from `attrs`, e.g., `patchPhase', etc.
if disabled then throw "${name} not supported for interpreter ${python.executable}" else python.stdenv.mkDerivation (attrs // {
  inherit doCheck;

  name = namePrefix + name;

  buildInputs = [
    python wrapPython setuptools
    (distutils-cfg.override { extraCfg = distutilsExtraCfg; })
  ] ++ buildInputs ++ pythonPath
    ++ (lib.optional (lib.hasSuffix "zip" attrs.src.name or "") unzip);

  propagatedBuildInputs = propagatedBuildInputs ++ [ recursivePthLoader ];

  pythonPath = [ setuptools ] ++ pythonPath;

  configurePhase = attrs.configurePhase or ''
    runHook preConfigure

    # patch python interpreter to write null timestamps when compiling python files
    # with following var we tell python to activate the patch so that python doesn't
    # try to update them when we freeze timestamps in nix store
    export DETERMINISTIC_BUILD=1

    # prepend following line to import setuptools before distutils
    # this way we make sure setuptools monkeypatches distutils commands
    # this way setuptools provides extra helpers such as "python setup.py test"
    sed -i '0,/import distutils/s//import setuptools;import distutils/' setup.py
    sed -i '0,/from distutils/s//import setuptools;from distutils/' setup.py

    runHook postConfigure
  '';

  checkPhase = attrs.checkPhase or ''
      runHook preCheck

      ${python}/bin/${python.executable} setup.py test

      runHook postCheck
  '';

  buildPhase = attrs.buildPhase or ''
    runHook preBuild

    ${python}/bin/${python.executable} setup.py build ${lib.concatStringsSep " " setupPyBuildFlags}

    runHook postBuild
  '';

  installPhase = attrs.installPhase or ''
    runHook preInstall

    mkdir -p "$out/lib/${python.libPrefix}/site-packages"

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --old-and-unmanageable \
      --prefix="$out" ${lib.concatStringsSep " " setupPyInstallFlags}

    # --install-lib:
    # sometimes packages specify where files should be installed outside the usual
    # python lib prefix, we override that back so all infrastructure (setup hooks)
    # work as expected

    # --old-and-unmanagable:
    # instruct setuptools not to use eggs but fallback to plan package install 
    # this also reduces one .pth file in the chain, but the main reason is to
    # force install process to install only scripts for the package we are
    # installing (otherwise it will install scripts also for dependencies)

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

    runHook postInstall
  '';

  postFixup = attrs.postFixup or ''
      wrapPythonPrograms

      # If a user installs a Python package, they probably also wants its
      # dependencies in the user environment profile (only way to find the
      # dependencies is to have them in the PYTHONPATH variable).
      # Allows you to do: $ PYTHONPATH=~/.nix-profile/lib/python2.7/site-packages python
      if test -e $out/nix-support/propagated-build-inputs; then
          ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
      fi

      # TODO: document
      createBuildInputsPth build-inputs "$buildInputStrings"
      for inputsfile in propagated-build-inputs propagated-native-build-inputs; do
        if test -e $out/nix-support/$inputsfile; then
            createBuildInputsPth $inputsfile "$(cat $out/nix-support/$inputsfile)"
        fi
      done
    '';

  shellHook = attrs.shellHook or ''
    if test -e setup.py; then
       tmp_path=/tmp/`pwd | md5sum | cut -f 1 -d " "`-$name
       mkdir -p $tmp_path/lib/${python.libPrefix}/site-packages
       ${preShellHook}
       export PATH="$tmp_path/bin:$PATH"
       export PYTHONPATH="$tmp_path/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
       ${python}/bin/${python.executable} setup.py develop --prefix $tmp_path
       ${postShellHook}
    fi
  '';

  meta = with lib.maintainers; {
    # default to python's platforms
    platforms = python.meta.platforms;
  } // meta // {
    # add extra maintainer(s) to every package
    maintainers = (meta.maintainers or []) ++ [ chaoflow iElectric ];
  };

})
