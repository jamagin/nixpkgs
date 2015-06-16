{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  version = "0.4.3";
  name = "vdirsyncer-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/untitaker/vdirsyncer/archive/${version}.tar.gz";
    sha256 = "0jrxmq8lq0dvqflmh42hhyvc3jjrg1cg3gzfhdcsskj9zz0m6wai";
  };

  propagatedBuildInputs = with pythonPackages; [
    icalendar
    click
    lxml
    setuptools
    requests_toolbelt
    requests2
    atomicwrites
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/untitaker/vdirsyncer;
    description = "Synchronize calendars and contacts";
    maintainers = with maintainers; [ matthiasbeyer jgeerds ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
