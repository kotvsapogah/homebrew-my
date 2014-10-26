require 'formula'

class Eclipse < Formula
    #url 'https://downloads.sourceforge.net/project/synfig/releases/0.64.1/source/ETL-0.04.17.tar.gz'
    homepage 'https://www.eclipse.org'
    os = `uname -s`.chomp
    if os == "Darwin"
        url 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-macosx-cocoa-x86_64.tar.gz&r=1'
        sha1 'dfa24dcf9917cc4a5338ed105750e50e68ea64b2'
    elsif os == "Linux"
        url 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-linux-gtk-x86_64.tar.gz&r=1'
    end
    version 'luna-SR1'

    def install
        prefix.install Dir["*"]
    end

end
