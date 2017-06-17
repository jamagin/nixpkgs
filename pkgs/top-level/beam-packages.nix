{ pkgs, stdenv, callPackage, wxGTK30, darwin }:

rec {
  lib = import ../development/beam-modules/lib.nix { inherit pkgs; };

  # Each
  interpreters = rec {

    # R18 is the default version.
    erlang = erlangR18; # The main switch to change default Erlang version.
    erlang_odbc = erlangR18_odbc;
    erlang_javac = erlangR18_javac;
    erlang_odbc_javac = erlangR18_odbc_javac;

    # These are standard Erlang versions, using the generic builder.
    erlangR16 = lib.callErlang ../development/interpreters/erlang/R16.nix {};
    erlangR16_odbc = erlangR16.override { odbcSupport = true; };
    erlangR17 = lib.callErlang ../development/interpreters/erlang/R17.nix {};
    erlangR17_odbc = erlangR17.override { odbcSupport = true; };
    erlangR17_javac = erlangR17.override { javacSupport = true; };
    erlangR17_odbc_javac = erlangR17.override {
      javacSupport = true; odbcSupport = true;
    };
    erlangR18 = lib.callErlang ../development/interpreters/erlang/R18.nix {
      wxGTK = wxGTK30;
    };
    erlangR18_odbc = erlangR18.override { odbcSupport = true; };
    erlangR18_javac = erlangR18.override { javacSupport = true; };
    erlangR18_odbc_javac = erlangR18.override {
      javacSupport = true; odbcSupport = true;
    };
    erlangR19 = lib.callErlang ../development/interpreters/erlang/R19.nix {
      wxGTK = wxGTK30;
    };
    erlangR19_odbc = erlangR19.override { odbcSupport = true; };
    erlangR19_javac = erlangR19.override { javacSupport = true; };
    erlangR19_odbc_javac = erlangR19.override {
      javacSupport = true; odbcSupport = true;
    };

    # Bash fork, using custom builder.
    erlang_basho_R16B02 = lib.callErlang ../development/interpreters/erlang/R16B02-8-basho.nix {
    };
    erlang_basho_R16B02_odbc = erlang_basho_R16B02.override {
      odbcSupport = true;
    };

    # Other Beam languages. These are built with beam.interpreters.erlang.
    elixir = callPackage ../development/interpreters/elixir { debugInfo = true; };
    lfe = callPackage ../development/interpreters/lfe { };
  };

  # Helper function to generate package set with a specific Erlang version.
  packagesWith = erlang: callPackage ../development/beam-modules { inherit erlang; };

  # Each field in this tuple represents all Beam packages in nixpkgs built with
  # appropriate Erlang/OTP version.
  packages = rec {

    # Packages built with default Erlang version.
    erlang = packagesWith interpreters.erlang;
    erlangR16 = packagesWith interpreters.erlangR16;
    erlangR17 = packagesWith interpreters.erlangR17;
    erlangR18 = packagesWith interpreters.erlangR18;
    erlangR19 = packagesWith interpreters.erlangR19;

  };
}
