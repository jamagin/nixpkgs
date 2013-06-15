/* Essential Haskell packages that must build. */

{ supportedSystems ? [ "x86_64-linux" ] }:

with import ./release-lib.nix { inherit supportedSystems; };

let

  ghc6104 = "ghc6104";
  ghc6123 = "ghc6123";
  ghc704  = "ghc704";
  ghc742  = "ghc742";
  ghc763  = "ghc763";
  default = [ ghc763 ];
  latest  = [ ];
  all     = [ ghc6104 ghc6123 ghc704 ghc742 ghc763 ];

  allBut = platform: pkgs.lib.filter (x: platform != x) all;

  filterSupportedSystems = systems: pkgs.lib.filter (x: pkgs.lib.elem x supportedSystems) systems;

  mapHaskellTestOn = attrs: pkgs.lib.mapAttrs mkJobs attrs;

  mkJobs = pkg: ghcs: builtins.listToAttrs (pkgs.lib.concatMap (ghc: mkJob ghc pkg) ghcs);

  mkJob = ghc: pkg:
    let
      pkgPath = ["haskellPackages_${ghc}" "${pkg}"];
      systems = filterSupportedSystems (pkgs.lib.attrByPath (pkgPath ++ ["meta" "platforms"]) [] pkgs);
    in
      map (system: mkSystemJob system ghc pkg) systems;

  mkSystemJob = system: ghc: pkg:
    pkgs.lib.nameValuePair "${ghc}" (pkgs.lib.setAttrByPath [system] ((pkgs.lib.getAttrFromPath ["haskellPackages_${ghc}" "${pkg}"] (pkgsFor system))));

in

mapTestOn {

  gitAndTools.gitAnnex = supportedSystems;
  jhc = supportedSystems;

}
//
mapHaskellTestOn {

  abstractPar = default;
  ACVector = default;
  aeson = default;
  AgdaExecutable = default;
  alex = all;
  alexMeta = default;
  alsaCore = default;
  alsaPcm = default;
  alternativeIo = default;
  ansiTerminal = default;
  ansiWlPprint = default;
  asn1Data = default;
  AspectAG = default;
  async = default ++ latest;
  attempt = default;
  attoparsec = default;
  attoparsecEnumerator = default;
  authenticate = default;
  base64Bytestring = default;
  baseUnicodeSymbols = default;
  benchpress = default;
  bimap = default;
  binaryShared = default;
  bitmap = default;
  bktrees = default;
  blazeBuilder = default;
  blazeBuilderEnumerator = default;
  blazeHtml = default;
  blazeTextual = default;
  bloomfilter = default;
  bmp = default;
  BNFC = default ++ latest;
  BNFCMeta = default;
  Boolean = default;
  bytestringMmap = default;
  bytestringNums = default;
  bytestringTrie = default;
  Cabal_1_16_0_3 = all;
  cabal2Ghci = default;
  cabal2nix = allBut ghc6104;
  cabalDev = default ++ latest;
  cabalGhci = default ++ latest;
  cabalInstall_1_16_0_2 = all;
  cabalInstall = all;
  cairo = default;
  caseInsensitive = default;
  cautiousFile = default;
  cereal = default;
  certificate = default;
  cgi = all;
  Chart = default;
  citeprocHs = default;
  clientsession = default;
  cmdargs = default;
  cmdlib = default ++ latest;
  colorizeHaskell = default;
  colour = default;
  comonadsFd = default;
  conduit = default;
  ConfigFile = default;
  continuedFractions = default;
  converge = default;
  convertible = default;
  cookie = default;
  cpphs = default;
  cprngAes = default;
  criterion = default ++ latest;
  cryptoApi = default;
  cryptocipher = default;
  Crypto = default;
  cryptohash = default;
  cssText = default;
  csv = default;
  darcs = default;
  dataAccessor = default;
  dataAccessorTemplate = default;
  dataDefault = default;
  dataenc = default;
  dataReify = default;
  datetime = default;
  DAV = default;
  dbus = default;
  derive = default;
  diagrams = default;
  Diff = default;
  digest = default;
  digestiveFunctorsHeist = default;
  digestiveFunctorsSnap = default;
  dimensional = default ++ latest;
  dimensionalTf = default ++ latest;
  directoryTree = default;
  dlist = default;
  dns = default;
  doctest = default ++ latest;
  dotgen = default;
  doubleConversion = default;
  editDistance = default;
  editline = default;
  emailValidate = default;
  entropy = default;
  enumerator = default;
  erf = default;
  failure = default;
  fclabels = default;
  feed = default;
  fgl = all;
  fileEmbed = default;
  filestore = default;
  fingertree = default;
  flexibleDefaults = default;
  fsnotify = [ ghc704 ghc742 ghc763 ];
  funcmp = all;
  gamma = default;
  gdiff = default;
  ghc = default;
  ghcEvents = default;
  ghcMod = default ++ latest;
  ghcMtl = default;
  ghcPaths = default;
  ghcSybUtils = default;
  githubBackup = default;
  github = default;
  gitit = default;
  glade = default;
  glib = default;
  Glob = default;
  gloss = default;
  GLUT = all;
  gnutls = default;
  graphviz = default ++ latest;
  gtk = default;
  gtksourceview2 = default;
  hackageDb = default ++ latest;
  haddock = all;
  hakyll = default;
  hamlet = default;
  happstackHamlet = default;
  happstackServer = default;
  happy = all;
  hashable = default;
  hashedStorage = default;
  haskeline = default;
  haskellLexer = default;
  haskellPlatform = all;
  haskellSrc = all;
  haskellSrcExts = default;
  haskellSrcMeta = default;
  HaXml = default;
  haxr = default;
  HDBC = default;
  HDBCPostgresql = default;
  HDBCSqlite3 = default;
  highlightingKate = default;
  hinotify = default;
  hint = default;
  hledger = default ++ latest;
  hledgerInterest = default ++ latest;
  hledgerLib = default ++ latest;
  hledgerWeb = default;
  hlint = default ++ latest;
  HList = default ++ latest;
  hmatrix = default;
  hoogle = default ++ latest;
  hopenssl = all;
  hostname = default;
  hp2anyCore = default;
  hp2anyGraph = default;
  hS3 = default;
  hscolour = default;
  hsdns = all;
  hsemail = allBut ghc6104;
  hslogger = default;
  hsloggerTemplate = default;
  hspec = default ++ latest;
  HsSyck = default;
  HStringTemplate = default ++ latest;
  hsyslog = all;
  html = all;
  HTTP = all;
  httpConduit = default;
  httpDate = default;
  httpdShed = default;
  httpTypes = default;
  HUnit = all;
  hxt = default;
  idris = default;
  IfElse = default;
  irc = default;
  iteratee = default;
  jailbreakCabal = all;
  json = default;
  jsonTypes = default;
  keter = default;
  lambdabot = default;
  languageCQuote = default;
  languageJavascript = default;
  largeword = default;
  lens = default;
  libxmlSax = default;
  liftedBase = default;
  ListLike = default;
  logfloat = default;
  mainlandPretty = default;
  maude = default;
  MaybeT = default;
  MemoTrie = default;
  mersenneRandomPure64 = default;
  mimeMail = default;
  MissingH = default;
  mmap = default;
  MonadCatchIOMtl = default;
  MonadCatchIOTransformers = default;
  monadControl = default;
  monadLoops = default;
  monadPar = default ++ latest;
  monadPeel = default;
  MonadPrompt = default;
  MonadRandom = default;
  mpppc = default;
  mtl = all;
  mtlparse = default;
  multiplate = default;
  multirec = default;
  murmurHash = default;
  mwcRandom = default;
  nat = default;
  nats = default;
  naturals = default;
  network = all;
  networkInfo = default;
  networkMulticast = default;
  networkProtocolXmpp = default;
  nonNegative = default;
  numericPrelude = default;
  numtype = default;
  numtypeTf = default;
  ObjectName = default;
  OneTuple = default;
  OpenAL = all;
  optparseApplicative = allBut ghc6104;
  packunused = default;
  pandoc = default ++ latest;
  pandocTypes = default;
  pango = default;
  parallel = all;
  parseargs = default;
  parsec3 = default;
  parsec = all;
  parsimony = default;
  pathPieces = default;
  pathtype = default;
  pcreLight = default;
  permutation = default ++ latest;
  persistent = default;
  persistentPostgresql = default;
  persistentSqlite = default;
  persistentTemplate = default;
  polyparse = default;
  ppm = default;
  prettyShow = default;
  primitive = all;
  PSQueue = default;
  pureMD5 = default;
  pwstoreFast = default;
  QuickCheck2 = default;
  QuickCheck = all;
  random = default ++ latest;
  randomFu = default;
  randomShuffle = default;
  randomSource = default;
  RangedSets = default;
  ranges = default;
  readline = default;
  recaptcha = default;
  regexBase = all;
  regexCompat = all;
  regexPCRE = default;
  regexPosix = all;
  regexpr = default;
  regexTDFA = default;
  regular = default;
  RSA = default;
  rvar = default;
  safe = default;
  SafeSemaphore = default;
  SDL = default;
  SDLImage = default;
  SDLMixer = default;
  SDLTtf = default;
  semigroups = default;
  sendfile = default;
  SHA = default;
  shake = default;
  Shellac = default;
  shelly = default;
  simpleSendfile = default;
  smallcheck = default ++ latest;
  SMTPClient = default;
  snapCore = default;
  snap = default;
  snapLoaderStatic = default;
  snapServer = default;
  split = default ++ latest;
  srcloc = default;
  stateref = default;
  StateVar = default;
  statistics = default;
  stbImage = default;
  stm = all;
  storableComplex = default;
  storableRecord = default;
  streamproc = all;
  strict = default;
  strptime = default;
  svgcairo = default;
  syb = [ ghc704 ghc742 ghc763 ];
  sybWithClass = default;
  sybWithClassInstancesText = default;
  tabular = default;
  tagged = default;
  tagsoup = default;
  tar = default ++ latest;
  Tensor = default;
  terminfo = default;
  testFramework = default ++ latest;
  testFrameworkHunit = default ++ latest;
  texmath = default;
  text = all;
  thLift = default;
  timeplot = default;
  tls = default;
  tlsExtra = default;
  transformers = all;
  transformersBase = default;
  transformersCompat = default;
  tuple = default;
  typeLevelNaturalNumber = default;
  uniplate = default;
  uniqueid = default;
  unixCompat = default;
  unorderedContainers = default;
  url = default;
  utf8Light = default;
  utf8String = default;
  utilityHt = default;
  uuagc = default;
  uuid = default;
  uulib = default ++ latest;
  uuOptions = default;
  uuParsinglib = default;
  vacuum = default;
  vcsRevision = default;
  Vec = default;
  vectorAlgorithms = default;
  vector = all;
  vectorSpace = default;
  vty = default;
  waiAppStatic = default;
  wai = default;
  waiExtra = default;
  waiLogger = default;
  warp = default;
  wlPprint = default ++ latest;
  wlPprintExtras = default;
  wlPprintTerminfo = default;
  X11 = default;
  xhtml = all;
  xmlConduit = default;
  xml = default;
  xmlHamlet = default;
  xmlTypes = default;
  xmobar = default ++ latest;
  xmonadContrib = default ++ latest;
  xmonad = default ++ latest;
  xmonadExtras = default ++ latest;
  xssSanitize = default;
  yesodAuth = default;
  yesodCore = default;
  yesod = default;
  yesodDefault = default;
  yesodForm = default;
  yesodJson = default;
  yesodPersistent = default;
  yesodStatic = default;
  zeromq3Haskell = default;
  zeromqHaskell = default;
  zipArchive = default;
  zipper = default;
  zlib = all;
  zlibBindings = default;
  zlibEnum = default;

}
