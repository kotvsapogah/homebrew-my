require 'formula'

class Llvm < Formula

    homepage  'http://llvm.org/'

    stable do
        url 'http://llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz'
        sha1 'f97f9d604b660c1695c054e134260d926e8ef4ee'

        resource 'clang' do
            url 'http://llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz'
            sha1 '06b252867a3d118c95ca279fd3c4ac05f6730551'
        end
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "pkg-config" => :build

    def ver; '3.6.0'; end # version suffix

    def install
        clang_buildpath = buildpath/'tools/clang'
        clang_buildpath.install resource('clang')

        install_prefix = lib/"llvm-#{ver}"

        #gmp_prefix = Formula["gmp"].opt_prefix

        args = [
            "--prefix=#{install_prefix}",
            "--disable-assertions",
            "--disable-debug",
            "--enable-optimized",
            "--disable-threads",
            "--disable-shared"
        ]

        system './configure', *args
        system 'make', 'VERBOSE=1'
        system 'make', 'VERBOSE=1', 'install'

        # Link executables to bin and add suffix to avoid conflicts
        Dir.glob(install_prefix/'bin/*') do |exec_path|
            basename = File.basename(exec_path)
            bin.install_symlink exec_path => "#{basename}"
        end

        # Also link man pages
        Dir.glob(install_prefix/'share/man/man1/*') do |manpage|
            basename = File.basename(manpage, ".1")
            man1.install_symlink manpage => "#{basename}.1"
        end
    end

    test do
        system "#{bin}/llvm-config", "--version"
    end

    def caveats
        s = ''
        s += "Extra tools are installed in #{HOMEBREW_PREFIX}/share/clang."
        s
    end

end
