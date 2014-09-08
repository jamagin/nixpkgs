{rubyLibsWith, callPackage, lib}:

{
  loadRubyEnv = path: config:
    let
      expr = callPackage path {};
      ruby = config.ruby;
      rubyLibs = rubyLibsWith ruby;
      gems = rubyLibs.importGems expr.gemset config.gemOverrides;
    in {
      inherit ruby; # TODO: Set ruby using expr.rubyVersion if not given.
      gemPath = map (drv: "${drv}/${ruby.gemPath}") (
        builtins.filter (value: lib.isDerivation value) (lib.attrValues gems)
      );
    };
}
