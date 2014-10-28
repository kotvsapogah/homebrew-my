require 'formula'

class Cling < Formula

    homepage  "http://root.cern.ch/drupal/content/cling-build-instructions"
    version "1.0"

    stable do
        url "http://root.cern.ch/git/llvm.git", :branch => "cling-patches"
        resource "clang" do
            url "http://root.cern.ch/git/clang.git", :branch => "cling-patches"
        end
        resource "cling" do
            url "http://root.cern.ch/git/cling.git"
        end
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "pkg-config" => :build

    def install
        install_prefix = lib/"cling"

        clang_buildpath = buildpath/'tools/clang'
        clang_buildpath.install resource('clang')

        cling_buildpath = buildpath/'tools/cling'
        cling_buildpath.install resource('cling')

        args = %W[
            --prefix=#{install_prefix}
            --disable-assertions
            --disable-debug
            --disable-threads
            --disable-shared
            --enable-cxx11
        ]

        system './configure', *args
        system 'make', 'VERBOSE=1'
        system 'make', 'VERBOSE=1', 'install'

        # Link executables to bin and add suffix to avoid conflicts
        Dir.glob(install_prefix/'bin/*') do |exec_path|
            basename = File.basename(exec_path)
            bin.install_symlink exec_path => "cling-#{basename}"
        end
    end

end
