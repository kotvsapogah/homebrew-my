require 'formula'

class Eclipse < Formula
    #url 'https://downloads.sourceforge.net/project/synfig/releases/0.64.1/source/ETL-0.04.17.tar.gz'
    homepage 'https://www.eclipse.org'
    os = `uname -s`.chomp
    if os == "Darwin"
        url 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/mars/1/eclipse-java-mars-1-macosx-cocoa-x86_64.tar.gz&r=1'
        sha256 '962b2984f80b15b38efe69148d2a8941571ea970'
    elsif os == "Linux"
        url 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/mars/1/eclipse-java-mars-1-linux-gtk-x86_64.tar.gz&r=1'
        sha256 '74cbc500a4ade717e115afb13b3a633f8a4db786'
    end
    version 'mars'

    def install
        prefix.install Dir["*"]
    end

end
