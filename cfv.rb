require 'formula'

# Can not test torrent files as Python bittorrent modules are not installed

class Cfv < Formula
  homepage 'http://cfv.sourceforge.net/'
  url 'http://sourceforge.net/projects/cfv/files/cfv/1.18.3/cfv-1.18.3.tar.gz'
  md5 '1be9039c2ab859103d70b6c4f4e5edf5'

  def install
    ## test
    #system "cd", "test"
    #system "env", "python", "test.py"
    #system "cd", ".."
    # install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  def test
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
