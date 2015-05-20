# Builder for Agda packages. Mostly inspired by the cabal builder.
#
# Contact: stdenv.lib.maintainers.fuuzetsu

{ stdenv, Agda, glibcLocales
, writeScriptBin
, extension ? (self: super: {})
}:

let
  optionalString = stdenv.lib.optionalString;
  filter = stdenv.lib.filter;
  concatMapStringsSep = stdenv.lib.strings.concatMapStringsSep;
  concatMapStrings = stdenv.lib.strings.concatMapStrings;
  unwords = stdenv.lib.strings.concatStringsSep " ";
  mapInside = xs: unwords (map (x: x + "/*") xs);
in
{ mkDerivation = args:
    let
      postprocess = x: x // {
        sourceDirectories = filter (y: !(y == null)) x.sourceDirectories;
        propagatedBuildInputs = filter (y : ! (y == null)) x.propagatedBuildInputs;
        propagatedUserEnvPkgs = filter (y : ! (y == null)) x.propagatedUserEnvPkgs;
        everythingFile = if x.everythingFile == "" then "Everything.agda" else x.everythingFile;
      };

      defaults = self : {
        # There is no Hackage for Agda so we require src.
        inherit (self) src name;

        isAgdaPackage = true;

        buildInputs = [ Agda ] ++ self.buildDepends;
        buildDepends = [];

        buildDependsAgda = filter
          (dep: dep ? isAgdaPackage && dep.isAgdaPackage)
          self.buildDepends;
        buildDependsAgdaShareAgda = map (x: x + "/share/agda") self.buildDependsAgda;

        # Not much choice here ;)
        LANG = "en_US.UTF-8";
        LOCALE_ARCHIVE = optionalString stdenv.isLinux "${glibcLocales}/lib/locale/locale-archive";

        everythingFile = "Everything.agda";

        propagatedBuildInputs = self.buildDependsAgda;
        propagatedUserEnvPkgs = self.buildDependsAgda;

        # Immediate source directories under which modules can be found.
        sourceDirectories = [ ];

        # This is used if we have a top-level element that only serves
        # as the container for the source and we only care about its
        # contents. The directories put here will have their
        # *contents* copied over as opposed to sourceDirectories which
        # would make a direct copy of the whole thing.
        topSourceDirectories = [ "src" ];

        # FIXME: `dirOf self.everythingFile` is what we really want, not hardcoded "./"
        includeDirs = self.buildDependsAgdaShareAgda
                      ++ self.sourceDirectories ++ self.topSourceDirectories
                      ++ [ "." ];
        buildFlags = unwords (map (x: "-i " + x) self.includeDirs);

        # We expose this as a mere convenience for any tools.
        AGDA_PACKAGE_PATH = concatMapStrings (x: x + ":") self.buildDependsAgdaShareAgda;

        # Makes a wrapper available to the user. Very useful in
        # nix-shell where all dependencies are -i'd.
        agdaWrapper = writeScriptBin "agda" ''
          ${Agda}/bin/agda ${self.buildFlags} "$@"
        '';

        # configurePhase is idempotent
        configurePhase = ''
          runHook preConfigure
          export PATH="${self.agdaWrapper}/bin:$PATH"
          runHook postConfigure
        '';

        buildPhase = ''
          runHook preBuild
          ${Agda}/bin/agda ${self.buildFlags} ${self.everythingFile}
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/share/agda
          cp -pR ${unwords self.sourceDirectories} ${mapInside self.topSourceDirectories} $out/share/agda
          runHook postInstall
        '';
      };
    in stdenv.mkDerivation
         (postprocess (let super = defaults self // args self;
                           self  = super // extension self super;
                       in self));
}
