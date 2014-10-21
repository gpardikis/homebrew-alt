require "formula"

class Hstr < Formula
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/releases/download/1.12/hh-1.12-src.tgz"
  sha1 "7098ebf487421f24757726852d64f05e6b880ecf"
  version "1.12"

  head do 
    depends_on "autoconf" => :build
    url "https://github.com/dvorka/hstr.git"
  end

  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "readline"
  depends_on "ncurses"

  def install
    
    readline = Formula["readline"]
    ENV['LIBDIRS'] = readline.opt_lib
    ENV['INCDIRS'] = readline.opt_include

    system "aclocal" if build.head?
    system "autoreconf -i" if build.head?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install" 
  end

  test do
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "hh", "--show-configuration"
  end

  def caveats; <<-EOS.undent
      To enable hh configuration, append to your .profile:
      if which -s hh; then eval "$(hh --show-configuration)"; fi
    EOS
  end
end
