{ pkgs, stdenv, callPackage, wxGTK30, darwin }:

rec {
  lib = import ../development/beam-modules/lib.nix { inherit pkgs; };

  interpreters = rec {

    # R18 is the Default version.
    erlang = erlangR18;
    erlang_odbc = erlangR18_odbc;
    erlang_javac = erlangR18_javac;
    erlang_odbc_javac = erlangR18_odbc_javac;

    # These are standard Erlang versions, using the generic builder.
    erlangR16 = lib.callErlang ../development/interpreters/erlang/R16.nix {} {};
    erlangR16_odbc = lib.callErlang ../development/interpreters/erlang/R16.nix {} {
      odbcSupport = true;
    };
    erlangR17 = lib.callErlang ../development/interpreters/erlang/R17.nix {} {};
    erlangR17_odbc = lib.callErlang ../development/interpreters/erlang/R17.nix {} {
      odbcSupport = true;
    };
    erlangR17_javac = lib.callErlang ../development/interpreters/erlang/R17.nix {} {
      javacSupport = true;
    };
    erlangR17_odbc_javac = lib.callErlang ../development/interpreters/erlang/R17.nix {} {
      javacSupport = true; odbcSupport = true;
    };
    erlangR18 = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
    } {};
    erlangR18_odbc = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
    } {
      odbcSupport = true;
    };
    erlangR18_javac = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
    } {
      javacSupport = true;
    };
    erlangR18_odbc_javac = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
    } {
      javacSupport = true; odbcSupport = true;
    };
    erlangR19 = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
    } {};
    erlangR19_odbc = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
    } {
      odbcSupport = true;
    };
    erlangR19_javac = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
    } {
      javacSupport = true;
    };
    erlangR19_odbc_javac = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
    } {
      javacSupport = true; odbcSupport = true;
    };

    # Bash fork, using custom builder.
    erlang_basho_R16B02 = callPackage ../development/interpreters/erlang/R16B02-8-basho.nix {
      inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
    };
    erlang_basho_R16B02_odbc = callPackage ../development/interpreters/erlang/R16B02-8-basho.nix {
      inherit (darwin.apple_sdk.frameworks) Carbon Cocoa;
      odbcSupport = true;
    };

    # Other Beam languages.
    elixir = callPackage ../development/interpreters/elixir { debugInfo = true; };
    lfe = callPackage ../development/interpreters/lfe { };
  };

  packages = rec {
    rebar = callPackage ../development/tools/build-managers/rebar { };
    rebar3-open = callPackage ../development/tools/build-managers/rebar3 { hermeticRebar3 = false; };
    rebar3 = callPackage ../development/tools/build-managers/rebar3 { hermeticRebar3 = true; };
    hexRegistrySnapshot = callPackage ../development/beam-modules/hex-registry-snapshot.nix { };
    fetchHex = callPackage ../development/beam-modules/fetch-hex.nix { };

    beamPackages = callPackage ../development/beam-modules { };
    hex2nix = beamPackages.callPackage ../development/tools/erlang/hex2nix { };
    cuter = callPackage ../development/tools/erlang/cuter { };

    relxExe = callPackage ../development/tools/erlang/relx-exe {};
  };
}
