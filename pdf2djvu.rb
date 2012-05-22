require 'formula'

class Pdf2djvu < Formula
  homepage ''
  url 'http://pdf2djvu.googlecode.com/files/pdf2djvu_0.7.12.tar.gz'
  md5 '4fd56c0763b56b4081fc9c85be16d9d7'

  depends_on 'poppler'
  depends_on 'djvulibre'
  depends_on 'libxslt'
  depends_on 'graphicsmagick'
  depends_on 'gnu-sed' => :build

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  # Use gnu sed instead of bsd sed
  def patches
    DATA
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test pdf2djvu`.
    system "false"
  end
end

__END__
--- pdf2djvu-0.7.12.old/tools/xml2c	2012-01-22 00:16:50.000000000 +0100
+++ pdf2djvu-0.7.12.new/tools/xml2c	2012-05-22 18:17:25.000000000 +0200
@@ -6,7 +6,7 @@
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation; version 2 dated June, 1991.
 
-exec sed \
+exec gsed \
   -e '/<!--# *\(.*\) *#-->/ { s//\1/; b; }' \
   -e '/<!--.*-->/ { s///g; b; }' \
   -e 's/\\\\/\\\\/g' \
