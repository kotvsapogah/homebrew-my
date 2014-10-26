require 'formula'

class Eclim < Formula
    homepage 'http://eclim.org/install.html'
    url "http://downloads.sourceforge.net/project/eclim/eclim/2.4.0/eclim_2.4.0.tar.gz"
    sha1 "717210349440b86946d1eaa56df8b034d7b86501"
    version "2.4.0"

    depends_on "ant"
    depends_on "eclipse"

    def install
        system "mkdir", "-p", "#{HOMEBREW_PREFIX}/share/vim/vimfiles/{autoload,doc,plugin,python,colors,ftdetect,ftplugin,indent,compiler,after}"
        system "chmod +x org.eclim/nailgun/configure"
        system "ant", 
            "-Declipse.home=#{HOMEBREW_PREFIX}/opt/eclipse", 
            "-Dvim.files=#{prefix}/share/vim/vimfiles"
    end

end
