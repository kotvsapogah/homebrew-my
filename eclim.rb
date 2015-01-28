require 'formula'

class Eclim < Formula
    homepage 'http://eclim.org/install.html'
    url "http://downloads.sourceforge.net/project/eclim/eclim/2.4.1/eclim_2.4.1.tar.gz"
    sha1 "79c01b5ec10499d2441708c3f42eb918d67d1556"
    version "2.4.1"

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
