{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, doit
, glibcLocales
, pytest
, pytestcov
, pytest-mock
, pygments
, pillow
, dateutil
, docutils
, Mako
, unidecode
, lxml
, Yapsy
, PyRSS2Gen
, Logbook
, blinker
, setuptools
, natsort
, requests
, piexif
, markdown
, phpserialize
, jinja2
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "Nikola";
  version = "7.8.6";

  # Nix contains only Python 3 supported version of doit, which is a dependency
  # of Nikola. Python 2 support would require older doit 0.29.0 (which on the
  # other hand doesn't support Python 3.3). So, just disable Python 2.
  disabled = !isPy3k;

  buildInputs = [ pytest pytestcov pytest-mock glibcLocales ];

  propagatedBuildInputs = [
    pygments pillow dateutil docutils Mako unidecode lxml Yapsy PyRSS2Gen
    Logbook blinker setuptools natsort requests piexif markdown phpserialize
    jinja2 doit
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "48d3a00c3fc9c61bcd305653a531949bdd777d9211434172549498fd8136e036";
  };

  meta = {
    homepage = "https://getnikola.com/";
    description = "A modular, fast, simple, static website and blog generator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
