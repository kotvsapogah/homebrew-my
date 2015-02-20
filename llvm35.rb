require 'formula'

class Llvm35 < Formula

    homepage  'http://llvm.org/'

    stable do
        url 'http://llvm.org/releases/3.5.1/llvm-3.5.1.src.tar.xz'
        sha1 '79638cf00584b08fd6eeb1e73ea69b331561e7f6'

        resource 'clang' do
            url 'http://llvm.org/releases/3.5.1/cfe-3.5.1.src.tar.xz'
            sha1 '39d79c0b40cec548a602dcac3adfc594b18149fe'
        end
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "pkg-config" => :build

    def ver; '3.5.1'; end # version suffix

    # LLVM installs its own standard library which confuses stdlib checking.
    #cxxstdlib_check :skip

    # Apple's libstdc++ is too old to build LLVM
    #fails_with :gcc
    #fails_with :llvm

    def install
        # Apple's libstdc++ is too old to build LLVM
        #ENV.libcxx if ENV.compiler == :clang
        ohai "libcxx: ", ENV.libcxx

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
            bin.install_symlink exec_path => "#{basename}-#{ver}"
        end

        # Also link man pages
        Dir.glob(install_prefix/'share/man/man1/*') do |manpage|
            basename = File.basename(manpage, ".1")
            man1.install_symlink manpage => "#{basename}-#{ver}.1"
        end
    end

    test do
        system "#{bin}/llvm-config-#{ver}", "--version"
    end

    def caveats
        s = ''
        s += "Extra tools are installed in #{HOMEBREW_PREFIX}/share/clang-#{ver}."
        s
    end

end
