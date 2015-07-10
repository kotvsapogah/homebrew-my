require 'formula'

class Ycm < Formula
    homepage "https://github.com/Valloric/YouCompleteMe"
    url "https://github.com/Valloric/YouCompleteMe", :using => :git
    version "3.6.0"

    depends_on "homebrew/dupes/zlib" => :build
    depends_on "cmake" => :build
    depends_on "kotvsapogah/my/llvm"

    def install
        for dir in %W[
            autoload doc plugin python
            colors ftdetect ftplugin indent compiler after]
            system "mkdir", "-p", "#{HOMEBREW_PREFIX}/share/vim/vimfiles/#{dir}"
        end

        os = `uname -s`.chomp
        if os == "Darwin"
            ext = "dylib"
        elsif os == "Linux"
            ext = "so"
        end

        python = "/usr/bin/python2.7"
        python_prefix = `#{python} -c "import sys; print sys.prefix"`.chomp
        python_includedir = `#{python} -c "from distutils import sysconfig; print sysconfig.get_python_inc()"`.chomp
        python_libdir = `#{python} -c "from distutils import sysconfig; print sysconfig.get_config_var('LIBDIR')"`.chomp
        python_version = `#{python} -c "from distutils import sysconfig; print sysconfig.get_config_var('VERSION')"`.chomp
        python_library = "#{python_libdir}/libpython#{python_version}.#{ext}" 
        ohai "Python prefix: ", python_prefix
        ohai "Python include: ", python_includedir
        ohai "Python library: ", python_library

        clang_path = Formula["llvm"].opt_prefix/"lib/llvm"

        mkdir "tmp_build"
        cd "tmp_build"
        system Formula["cmake"].bin/"cmake", "-G", "Unix Makefiles",
            "-DPATH_TO_LLVM_ROOT=#{clang_path}",
            "-DPYTHON_EXECUTABLE=#{python}",
            "-DPYTHON_LIBRARY=#{python_library}",
            "-DPYTHON_INCLUDE_DIR=#{python_includedir}",
            "../third_party/ycmd/cpp"
        system "make", "ycm_support_libs"
        cd "#{buildpath}"
        `rm -rf tmp_build`
        (prefix/"share/vim/vimfiles").install Dir["*"]

    end

end
