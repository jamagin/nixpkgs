{ stdenv, fetchFromGitHub, writeScript, glibcLocales
, python2Packages, imagemagick

, enableAcousticbrainz ? true
, enableAcoustid       ? true
, enableBadfiles       ? true, flac ? null, mp3val ? null
, enableConvert        ? true, ffmpeg ? null
, enableDiscogs        ? true
, enableEmbyupdate     ? true
, enableFetchart       ? true
, enableKeyfinder      ? true, keyfinder-cli ? null
, enableLastfm         ? true
, enableMpd            ? true
, enableReplaygain     ? true, bs1770gain ? null
, enableThumbnails     ? true
, enableWeb            ? true

# External plugins
, enableAlternatives   ? false
, enableCopyArtifacts  ? false

, bashInteractive, bash-completion
}:

assert enableAcoustid    -> python2Packages.pyacoustid     != null;
assert enableBadfiles    -> flac != null && mp3val != null;
assert enableConvert     -> ffmpeg != null;
assert enableDiscogs     -> python2Packages.discogs_client != null;
assert enableFetchart    -> python2Packages.responses      != null;
assert enableKeyfinder   -> keyfinder-cli != null;
assert enableLastfm      -> python2Packages.pylast         != null;
assert enableMpd         -> python2Packages.mpd            != null;
assert enableReplaygain  -> bs1770gain                    != null;
assert enableThumbnails  -> python2Packages.pyxdg          != null;
assert enableWeb         -> python2Packages.flask          != null;

with stdenv.lib;

let
  optionalPlugins = {
    acousticbrainz = enableAcousticbrainz;
    badfiles = enableBadfiles;
    chroma = enableAcoustid;
    convert = enableConvert;
    discogs = enableDiscogs;
    embyupdate = enableEmbyupdate;
    fetchart = enableFetchart;
    keyfinder = enableKeyfinder;
    lastgenre = enableLastfm;
    lastimport = enableLastfm;
    mpdstats = enableMpd;
    mpdupdate = enableMpd;
    replaygain = enableReplaygain;
    thumbnails = enableThumbnails;
    web = enableWeb;
  };

  pluginsWithoutDeps = [
    "beatport" "bench" "bpd" "bpm" "bucket" "cue" "duplicates" "edit" "embedart"
    "export" "filefilter" "freedesktop" "fromfilename" "ftintitle" "fuzzy" "hook" "ihate"
    "importadded" "importfeeds" "info" "inline" "ipfs" "lyrics"
    "mbcollection" "mbsubmit" "mbsync" "metasync" "missing" "permissions" "play"
    "plexupdate" "random" "rewrite" "scrub" "smartplaylist" "spotify" "the"
    "types" "zero"
  ];

  enabledOptionalPlugins = attrNames (filterAttrs (_: id) optionalPlugins);

  allPlugins = pluginsWithoutDeps ++ attrNames optionalPlugins;
  allEnabledPlugins = pluginsWithoutDeps ++ enabledOptionalPlugins;

  testShell = "${bashInteractive}/bin/bash --norc";
  completion = "${bash-completion}/share/bash-completion/bash_completion";

in python2Packages.buildPythonApplication rec {
  name = "beets-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "beetbox";
    repo = "beets";
    rev = "v${version}";
    sha256 = "1yj2m7l157lldhxanwifp3yv1c6k649iwhn061mcf26q4n8qmspk";
  };

  propagatedBuildInputs = [
    python2Packages.enum34
    python2Packages.jellyfish
    python2Packages.munkres
    python2Packages.musicbrainzngs
    python2Packages.mutagen
    python2Packages.pathlib
    python2Packages.pyyaml
    python2Packages.unidecode
  ] ++ optional enableAcoustid     python2Packages.pyacoustid
    ++ optional (enableFetchart
              || enableEmbyupdate
              || enableAcousticbrainz)
                                   python2Packages.requests2
    ++ optional enableConvert      ffmpeg
    ++ optional enableDiscogs      python2Packages.discogs_client
    ++ optional enableKeyfinder    keyfinder-cli
    ++ optional enableLastfm       python2Packages.pylast
    ++ optional enableMpd          python2Packages.mpd
    ++ optional enableThumbnails   python2Packages.pyxdg
    ++ optional enableWeb          python2Packages.flask
    ++ optional enableAlternatives (import ./alternatives-plugin.nix {
      inherit stdenv python2Packages fetchFromGitHub;
    })
    ++ optional enableCopyArtifacts (import ./copyartifacts-plugin.nix {
      inherit stdenv python2Packages fetchFromGitHub;
    });

  buildInputs = with python2Packages; [
    beautifulsoup4
    imagemagick
    mock
    nose
    rarfile
    responses
  ];

  patches = [
    ./replaygain-default-bs1770gain.patch
    ./keyfinder-default-bin.patch
  ];

  postPatch = ''
    sed -i -e '/assertIn.*item.*path/d' test/test_info.py
    echo echo completion tests passed > test/rsrc/test_completion.sh

    sed -i -e '/^BASH_COMPLETION_PATHS *=/,/^])$/ {
      /^])$/i u"${completion}"
    }' beets/ui/commands.py
  '' + optionalString enableBadfiles ''
    sed -i -e '/self\.run_command(\[/ {
      s,"flac","${flac.bin}/bin/flac",
      s,"mp3val","${mp3val}/bin/mp3val",
    }' beetsplug/badfiles.py
  '' + optionalString enableConvert ''
    sed -i -e 's,\(util\.command_output(\)\([^)]\+\)),\1[b"${ffmpeg.bin}/bin/ffmpeg" if args[0] == b"ffmpeg" else args[0]] + \2[1:]),' beetsplug/convert.py 
  '' + optionalString enableReplaygain ''
    sed -i -re '
      s!^( *cmd *= *b?['\'''"])(bs1770gain['\'''"])!\1${bs1770gain}/bin/\2!
    ' beetsplug/replaygain.py
    sed -i -e 's/if has_program.*bs1770gain.*:/if True:/' \
      test/test_replaygain.py
  '';

  doCheck = true;

  preCheck = ''
    (${concatMapStrings (s: "echo \"${s}\";") allPlugins}) \
      | sort -u > plugins_defined
    find beetsplug -mindepth 1 \
      \! -path 'beetsplug/__init__.py' -a \
      \( -name '*.py' -o -path 'beetsplug/*/__init__.py' \) -print \
      | sed -n -re 's|^beetsplug/([^/.]+).*|\1|p' \
      | sort -u > plugins_available

    if ! mismatches="$(diff -y plugins_defined plugins_available)"; then
      echo "The the list of defined plugins (left side) doesn't match" \
           "the list of available plugins (right side):" >&2
      echo "$mismatches" >&2
      exit 1
    fi
  '';

  checkPhase = ''
    runHook preCheck

    LANG=en_US.UTF-8 \
    LOCALE_ARCHIVE=${assert stdenv.isLinux; glibcLocales}/lib/locale/locale-archive \
    BEETS_TEST_SHELL="${testShell}" \
    BASH_COMPLETION_SCRIPT="${completion}" \
    HOME="$(mktemp -d)" \
      nosetests -v

    runHook postCheck
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    tmphome="$(mktemp -d)"

    EDITOR="${writeScript "beetconfig.sh" ''
      #!${stdenv.shell}
      cat > "$1" <<CFG
      plugins: ${concatStringsSep " " allEnabledPlugins}
      CFG
    ''}" HOME="$tmphome" "$out/bin/beet" config -e
    EDITOR=true HOME="$tmphome" "$out/bin/beet" config -e

    runHook postInstallCheck
  '';

  meta = {
    description = "Music tagger and library organizer";
    homepage = http://beets.radbox.org;
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig domenkozar pjones profpatsch ];
    platforms = platforms.linux;
  };
}
