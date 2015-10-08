require 'formula'

class Eclim < Formula
    homepage 'http://eclim.org/install.html'
    url "http://downloads.sourceforge.net/project/eclim/eclim/2.5.0/eclim_2.5.0.tar.gz"
    sha1 "ea27ee2481644d97909a71e72922a7170d13510e"
    version "2.5.0"

    depends_on "ant"
    depends_on "eclipse"

    def install
        for dir in %W[
            autoload doc plugin python
            colors ftdetect ftplugin indent compiler after]
            system "mkdir", "-p", "#{HOMEBREW_PREFIX}/share/vim/vimfiles/#{dir}"
        end

        system "chmod +x org.eclim/nailgun/configure"
        system "ant", 
            "-Declipse.home=#{HOMEBREW_PREFIX}/opt/eclipse", 
            "-Dvim.files=#{prefix}/share/vim/vimfiles"
    end

end
