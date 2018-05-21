require 'formula'

class Llvm < Formula

    homepage  'http://llvm.org/'

    stable do
        url 'https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz'
        sha256 '1ff53c915b4e761ef400b803f07261ade637b0c269d99569f18040f3dcee4408'

        resource 'clang' do
            url 'https://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz'
            sha256 'e07d6dd8d9ef196cfc8e8bb131cbd6a2ed0b1caf1715f9d05b0f0eeaddb6df32'
        end
    end

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
    depends_on "pkg-config" => :build

    def ver; '6.0.0'; end # version suffix

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
            system "cmake", "--build", ".", "--", "-j4"
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
