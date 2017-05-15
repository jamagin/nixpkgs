/*
Run with:
nix-build -E 'with import <nixpkgs> { }; callPackage ./test.nix {}' --show-trace; and cat result

Confusingly, the ideal result ends with something like:
error: build of ‘/nix/store/3245f3dcl2wxjs4rci7n069zjlz8qg85-test-results.tap.drv’ failed
*/
{ stdenv, writeText, lib, ruby, defaultGemConfig, callPackage }@defs:
let
  test = import ./testing.nix;
  tap = import ./tap-support.nix;
  stubs = import ./stubs.nix defs;
  should = import ./assertions.nix { inherit test lib; };

  basicEnv = callPackage ./basic.nix stubs;
  bundlerEnv = callPackage ./default.nix stubs // {
    inherit basicEnv;
  };

  testConfigs = {
    inherit lib;
    gemConfig =  defaultGemConfig;
  };
  functions = (import ./functions.nix testConfigs);

  justName = bundlerEnv {
    name = "test-0.1.2";
    gemset = ./test/gemset.nix;
  };

  pnamed = bundlerEnv {
    pname = "test";
    gemdir = ./test;
    gemset = ./test/gemset.nix;
    gemfile = ./test/Gemfile;
    lockfile = ./test/Gemfile.lock;
  };

  results = builtins.concatLists [
    (test.run "Filter empty gemset" {} (set: functions.filterGemset {inherit ruby; groups = ["default"]; } set == {}))
    ( let gemSet = { test = { groups = ["x" "y"]; }; };
      in
      test.run "Filter matches a group" gemSet (set: functions.filterGemset {inherit ruby; groups = ["y" "z"];} set == gemSet))
    ( let gemSet = { test = { platforms = []; }; };
      in
      test.run "Filter matches empty platforms list" gemSet (set: functions.filterGemset {inherit ruby; groups = [];} set == gemSet))
    ( let gemSet = { test = { platforms = [{engine = ruby.rubyEngine; version = ruby.version.majMin;}]; }; };
      in
      test.run "Filter matches on platform" gemSet (set: functions.filterGemset {inherit ruby; groups = [];} set == gemSet))
    ( let gemSet = { test = { groups = ["x" "y"]; }; };
      in
      test.run "Filter excludes based on groups" gemSet (set: functions.filterGemset {inherit ruby; groups = ["a" "b"];} set == {}))
    (test.run "bundlerEnv { name }" justName {
      name = should.equal "test-0.1.2";
    })
    (test.run "bundlerEnv { pname }" pnamed
    [
      (should.haveKeys [ "name" "env" "postBuild" ])
      {
        name = should.equal "test-0.1.2";
        env = should.beASet;
        postBuild = should.havePrefix "/nix/store";
      }
    ])
  ];
in
  writeText "test-results.tap" (tap.output results)
