require 'formula'

# Can not test torrent files as Python bittorrent modules are not installed

class Cfv < Formula
  homepage 'http://cfv.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz'
  sha256 'ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6'

  def install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    system "#{bin}/cfv"
  end

  # remove bittorrent tests from test.py, they are broken
  def patches
    DATA
  end

end

__END__
diff -rupN cfv-1.18.3.old/test/test.py cfv-1.18.3.new/test/test.py
--- cfv-1.18.3.old/test/test.py	2008-06-23 01:59:01.000000000 +0200
+++ cfv-1.18.3.new/test/test.py	2012-05-23 11:18:47.000000000 +0200
@@ -1379,7 +1379,7 @@ def all_tests():
 	C_test("csv2","-t csv2")
 	C_test("csv4","-t csv4")
 	C_test("crc")
-	private_torrent_test()
+	#private_torrent_test()
 	#test_generic("../cfv -V -T -f test.md5",cfv_test)
 	#test_generic("../cfv -V -tcsv -T -f test.md5",cfv_test)
 	for t in allfmts():
