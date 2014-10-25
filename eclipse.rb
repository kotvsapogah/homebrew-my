require 'formula'

class Eclipse < Formula
    homepage 'https://www.eclipse.org'
    #url 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/luna/SR1/eclipse-java-luna-SR1-macosx-cocoa-x86_64.tar.gz&r=1'

    if true
        url 'https://downloads.sourceforge.net/project/synfig/releases/0.64.1/source/ETL-0.04.17.tar.gz'
    end
    #sha1 'b262c92b6533183640a92db6091d74765b22c0d3'
    version 'luna-SR1'

    def install
        (prefix/"local/eclipse").install Dir["*"]
    end

end
