{ stdenv, runCommand, writeText, writeScriptBin, ruby, lib, callPackage
, gemFixes, fetchurl, fetchgit, buildRubyGem
}@defs:

# This is a work-in-progress.
# The idea is that his will replace load-ruby-env.nix,
# using (a patched) bundler to handle the entirety of the installation process.

{ name, gemset, gemfile, lockfile, ruby ? defs.ruby, fixes ? gemFixes }@args:

let
  const = x: y: x;

  fetchers.path = attrs: attrs.src.path;
  fetchers.gem = attrs: fetchurl {
    url = "${attrs.src.source or "https://rubygems.org"}/downloads/${attrs.name}-${attrs.version}.gem";
    inherit (attrs.src) sha256;
  };
  fetchers.git = attrs: fetchgit {
    inherit (attrs.src) url rev sha256 fetchSubmodules;
    leaveDotGit = true;
  };

  fixSpec = attrs:
    attrs // (fixes."${attrs.name}" or (const {})) attrs;

  instantiate = (attrs:
    let
      withFixes = fixSpec attrs;
      withSource = withFixes //
        (if (lib.isDerivation withFixes.src || builtins.isString withFixes.src)
           then { source = attrs.src; }
           else { source = attrs.src; src = (fetchers."${attrs.src.type}" attrs); });

    in
      withSource
  );

  instantiated = lib.flip lib.mapAttrs (import gemset) (name: attrs:
    instantiate (attrs // { inherit name; })
  );

  runRuby = name: env: command:
    runCommand name env ''
      ${ruby}/bin/ruby ${writeText name command}
    '';

  # TODO: include json_pure, so the version of ruby doesn't matter.
  # not all rubies have support for JSON built-in,
  # so we'll convert JSON to ruby expressions.
  json2rb = writeScriptBin "json2rb" ''
    #!${ruby}/bin/ruby
    begin
      require 'json'
    rescue LoadError => ex
      require 'json_pure'
    end

    puts JSON.parse(STDIN.read).inspect
  '';

  # dump the instantiated gemset as a ruby expression.
  serializedGemset = runCommand "gemset.rb" { json = builtins.toJSON instantiated; } ''
    printf '%s' "$json" | ${json2rb}/bin/json2rb > $out
  '';

  # this is a mapping from a source type and identifier (uri/path/etc)
  # to the pure store path.
  # we'll use this from the patched bundler to make fetching sources pure.
  sources = runRuby "sources.rb" { gemset = serializedGemset; } ''
    out    = ENV['out']
    gemset = eval(File.read(ENV['gemset']))

    sources = {
      "git"  => { },
      "path" => { },
      "gem"  => { },
      "svn"  => { }
    }

    gemset.each_value do |spec|
      type = spec["source"]["type"]
      val = spec["src"]
      key =
        case type
        when "gem"
          spec["name"]
        when "git"
          spec["source"]["url"]
        when "path"
          spec["source"]["originalPath"]
        when "svn"
          nil # TODO
        end

      sources[type][key] = val if key
    end

    File.open(out, "wb") do |f|
      f.print sources.inspect
    end
  '';

  # rewrite PATH sources to point into the nix store.
  pureLockfile = runRuby "pureLockfile" { inherit sources; } ''
    out   = ENV['out']
    paths = eval(File.read(ENV['sources']))

    lockfile = File.read("${lockfile}")

    paths.each_pair do |impure, pure|
      lockfile.gsub!(/^  remote: #{Regexp.escape(impure)}/, "  remote: #{pure}")
    end

    File.open(out, "wb") do |f|
      f.print lockfile
    end
  '';

in

stdenv.mkDerivation {
  inherit name;
  outputs = [
    "out"     # the installed libs/bins
    "bundler" # supporting files for bundler
  ];
  phases = [ "installPhase" "fixupPhase" ];
  installPhase = ''
    # Copy the Gemfile and Gemfile.lock
    mkdir -p $bundler
    BUNDLE_GEMFILE=$bundler/Gemfile
    cp ${gemfile} $BUNDLE_GEMFILE
    cp ${pureLockfile} $BUNDLE_GEMFILE.lock

    export NIX_GEM_SOURCES=${sources}

    export GEM_HOME=$out/${ruby.gemPath}
    export GEM_PATH=$GEM_HOME
    mkdir -p $GEM_HOME

    bundler install
  '';
  passthru = {
    inherit ruby;
  };
}
