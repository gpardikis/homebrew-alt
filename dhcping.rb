require 'formula'

class Dhcping < Formula
  homepage 'http://www.mavetju.org/unix/general.php'
  url 'http://www.mavetju.org/download/dhcping-1.2.tar.gz'
  md5 'c4b22bbf3446c8567e371c40aa552d5d'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--bindir=#{sbin}", "--mandir=#{man}"
    system "make install"
  end

  def test
    system "dhcping"
  end

  def caveats; <<-EOS.undent
    Dhcping should only be ran by root or be installed as setuid root.
    You can run dhcping via sudo, or you can install the binary as
    setuid root:
      sudo chown root:wheel #{sbin}/dhcping
      sudo chmod u+s #{sbin}/dhcping
    EOS
  end

end
