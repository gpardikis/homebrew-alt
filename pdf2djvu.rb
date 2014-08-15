require 'formula'

class Pdf2djvu < Formula
  homepage 'https://code.google.com/p/pdf2djvu/'
  url 'https://pdf2djvu.googlecode.com/files/pdf2djvu_0.7.17.tar.gz'
  sha1 'e15c1922c759cfe868fdc0078404fc77e2a6b548'

  depends_on 'poppler'
  depends_on 'djvulibre'
  depends_on 'libxslt'
  depends_on 'gettext'
  depends_on 'graphicsmagick'
  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build

  def install

    # Clang doesn't thave support for OpenMP
    if ENV.compiler == :clang
      opoo <<-EOS.undent
        Clang currently does not have OpenMP support.
        Parallel page rendering will be disabled.
        If you have gcc, you can build pdf2djvu with gcc:
          brew install pdf2djvu --use-gcc
      EOS
    end

    system "./configure", "--prefix=#{prefix}" 
    system "make install"

  end

  # Patches:
  # 1. Use gnu sed instead of bsd sed
  # 2. Remove false-positive libDJVU test section from configure script
  def patches
    DATA
  end

  def test
    system "make test"
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
--- pdf2djvu-0.7.17.dist/configure	2013-10-15 12:31:48.000000000 +0100
+++ pdf2djvu-0.7.17/configure	2013-10-15 12:32:25.000000000 +0100
@@ -3191,50 +3191,6 @@ $as_echo "incomplete set of tools" >&6; 
   fi
 done
 
-# Test for Debian bug #458211 <http://bugs.debian/458211>.
-# csepdjvu affected by the bug is unable to use subsample ratio 12.
-# Prior to pdf2djvu 0.5.0, pdf2djvu simply dissalowed subsample ratio 12 by
-# itself.
-echo 'P1 12 12' > conftest.458211.pbm
-yes 0 | head -n 144 >> conftest.458211.pbm
-"$djvulibre_bin_path/cjb2" conftest.458211.pbm conftest.458211.djvu
-"$djvulibre_bin_path/ddjvu" -format=rle conftest.458211.djvu conftest.458211.sep
-printf 'P6 1 1 255 xxx' >> conftest.458211.sep
-"$djvulibre_bin_path/csepdjvu" conftest.458211.sep conftest.458211.djvu 2>/dev/null || djvulibre_bugs="$djvulibre_bugs 458211"
-
-# Test for Debian bug #471149 <http://bugs.debian.org/471149>.
-# djvused affected by the bug is unable to correctly set annotations.
-printf 'P1 3 3 0 0 0 0 0 0 0 0 0' > conftest.471149.pbm
-"$djvulibre_bin_path/cjb2" conftest.471149.pbm conftest.471149.djvu
-cat > conftest.471149.djvused <<_ACEOF
-select 1
-set-ant
-(x)
-.
-_ACEOF
-"$djvulibre_bin_path/djvused" -f conftest.471149.djvused -s conftest.471149.djvu
-if ! "$djvulibre_bin_path/djvused" -e output-ant conftest.471149.djvu | grep '(x)' > /dev/null
-then
-  djvulibre_bugs="$djvulibre_bugs 471149"
-fi
-
-# Test for Debian bug #458086 <http://bugs.debian.org/458086>.
-# djvused affected by the bug is unable to set bookmarks for indirect
-# multi-page documents.
-# Prior to pdf2djvu 0.5.3, the bug was worked around.
-printf 'P1 3 3 0 0 0 0 0 0 0 0 0 0' > conftest.458086.pbm
-"$djvulibre_bin_path/cjb2" conftest.458086.pbm conftest.458086.p1.djvu
-"$djvulibre_bin_path/cjb2" conftest.458086.pbm conftest.458086.p2.djvu
-printf 'AT&TFORM\0\0\0\065DJVMDIRM\0\0\0\051\001\0\002\377\377\306\277\212' > conftest.458086.djvu
-printf '\037\353\113\377\100\216\067\206\077\154\276\170\002\074\223\233' >> conftest.458086.djvu
-printf '\027\127\026\147\035\172\353\127\370\363\176\144\062\102\210\322\117' >> conftest.458086.djvu
-printf '(bookmarks ("" ""))' > conftest.458086.outline
-"$djvulibre_bin_path/djvused" -s -e 'set-outline conftest.458086.outline' conftest.458086.djvu
-if ! "$djvulibre_bin_path/djvused" -e print-outline conftest.458086.djvu | grep '(bookmarks' > /dev/null
-then
-  djvulibre_bugs="$djvulibre_bugs 458086"
-fi
-
 if test -n "$djvulibre_bugs"
 then
   result=''
