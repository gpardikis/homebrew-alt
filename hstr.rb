require "formula"

class Hstr < Formula
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/1.19.tar.gz"
  sha256 "1783fa175416e99cb540cbc47092b87dc2362dc2a2f988f59eb66b0d793e4136"
  version "1.19"

  head do
    url "https://github.com/dvorka/hstr.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "readline"
  depends_on "ncurses"

  def install

    readline = Formula["readline"]
    ENV['LIBDIRS'] = readline.opt_lib
    ENV['INCDIRS'] = readline.opt_include

    system "aclocal"
    system "autoreconf -i"

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
