require 'formula'

class Llvm < Formula

    homepage  'http://llvm.org/'

    stable do
        url 'http://llvm.org/releases/3.8.0/llvm-3.8.0.src.tar.xz'
        sha256 '555b028e9ee0f6445ff8f949ea10e9cd8be0d084840e21fbbe1d31d51fc06e46'

        resource 'clang' do
            url 'http://llvm.org/releases/3.8.0/cfe-3.8.0.src.tar.xz'
            sha256 '04149236de03cf05232d68eb7cb9c50f03062e339b68f4f8a03b650a11536cf9'
        end
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "pkg-config" => :build

    def ver; '3.8.0'; end # version suffix

    def install
        clang_buildpath = buildpath/'tools/clang'
        clang_buildpath.install resource('clang')

        install_prefix = lib/"llvm"

        ##gmp_prefix = Formula["gmp"].opt_prefix
        #args = [
            #"--prefix=#{install_prefix}",
            #"--disable-assertions",
            #"--disable-debug",
            #"--enable-optimized",
            #"--disable-threads",
            #"--disable-shared"
        #]
        #system './configure', *args
        #
        args = [
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_INSTALL_PREFIX=#{install_prefix}"
        ]

        ohai "STD CMAKE ARGS", *std_cmake_args
        mktemp do
            #system "cmake", "--build", buildpath, *(std_cmake_args + args)
            system "cmake", *(args), buildpath
            system "cmake", "--build", "."
            system "cmake", "--build", ".", "--target", "install"
        end

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

end
