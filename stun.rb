require 'formula'

class Stun < Formula
  homepage 'http://stun.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/stun/stun/0.97/stund-0.97.tgz'
  md5 '1be9039c2ab859103d70b6c4f4e5edf5'
  sha256 '83e1bf9c21399244c5e8ad19789121a3537399d6523a887a5abc6187adcdb1d7'
  version '0.97'

  def install
    system "make"
    system "install", "-d", "#{bin}", "#{sbin}"
    system "install", "-c", "stun", "#{bin}"
    system "install", "-c", "stund", "#{sbin}"
  end

  def test
    system "#{bin}/stun", "stun.sipgate.net"
  end

  def patches
    DATA
  end

end

__END__
diff -rupN stund.vanilla/Makefile stund/Makefile
--- stund.vanilla/Makefile	2012-01-26 11:02:46.000000000 +0000
+++ stund/Makefile	2015-09-23 13:21:32.000000000 +0100
@@ -27,22 +27,22 @@ LDFLAGS+=-g -O -Wall
 #LDFLAGS+= -lnsl -lsocket
 
 
-all: server client 
+all: stund stun 
 
 clean:
-	- rm *.o server client tlsServer 
+	- rm *.o stund stun tlsServer 
 
 tar: $(TARS)
 	cd ..; tar cvfz `date +"stund/stund_$(VERSION)_$(PROG)%b%d.tgz"` \
 			 $(addprefix stund/, $(TARS))
 
-server: server.o stun.o udp.o 
+stund: server.o stun.o udp.o 
 	$(CXX) $(LDFLAGS) -o $@  $^
 
 tlsServer: tlsServer.o stun.o udp.o
 	$(CXX) $(LDFLAGS) -o $@  $^
 
-client: client.o stun.o udp.o 
+stun: client.o stun.o udp.o 
 	$(CXX) $(LDFLAGS) -o $@  $^
 
 %.o:%.cxx
diff -rupN stund.vanilla/udp.h stund/udp.h
--- stund.vanilla/udp.h	2012-01-26 11:02:46.000000000 +0000
+++ stund/udp.h	2015-09-23 12:52:21.000000000 +0100
@@ -3,7 +3,7 @@
 
 
 #ifdef __MACH__
-typedef int socklen_t;
+// typedef int socklen_t;
 #endif
 
 #include <errno.h>

