{ rubyTool }:

rubyTool {
  name = "corundum-0.6.2";
  gemdir = ./.;
  meta = {
    description = "Tool and libraries for maintaining Ruby gems.";
    homepage    = http://sass-lang.com/;
    license     = licenses.mit;
    maintainers = [ maintainers.nyarly ];
    platforms   = platforms.unix;
  };
}
