with builtins;
let
  withIndexes = list: genList (idx: (elemAt list idx) // {index = idx;}) (length list);

  testLine = report: "${okStr report} ${toString report.index} ${report.description}" + testDirective report + testYaml report;

  testDirective = report: "";

  testYaml = report: "";

  okStr = { result, ...}: if result == "pass" then "ok" else "not ok";
in
  {
    output = reports: ''
      TAP version 13
      1..${toString (length reports)}'' + (foldl' (l: r: l + "\n" + r) "" (map testLine (withIndexes reports))) + ''

      # Finished at ${toString currentTime}
      '';
  }
