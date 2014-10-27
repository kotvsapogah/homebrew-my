require 'formula'

class Ycm < Formula
    homepage "https://github.com/Valloric/YouCompleteMe"
    url "https://github.com/Valloric/YouCompleteMe", :using => :git
    version "3.5.0"

    depends_on "kotvsapogah/my/llvm35"

    def install
        system "mkdir", "-p", "#{HOMEBREW_PREFIX}/share/vim/vimfiles/{autoload,doc,plugin,python,colors,ftdetect,ftplugin,indent,compiler,after}"

        os = `uname -s`.chomp
        if os == "Darwin"
            ext = "dylib"
        elsif os == "Linux"
            ext = "so"
        end
        python_prefix = `#{ENV['HOME']}/packages/bin/python2 -c "import sys; print sys.prefix"`.chomp
        ohai "Python prefix: ", python_prefix

        clang_path = Formula["llvm35"].opt_prefix/"lib/llvm-3.5"

        mkdir "tmp_build"
        cd "tmp_build"
        system "cmake", "-G", "Unix Makefiles",
            "-DPATH_TO_LLVM_ROOT=#{clang_path}",
            "-DPYTHON_EXECUTABLE=#{python_prefix}/bin/python",
            "-DPYTHON_LIBRARY=#{python_prefix}/lib/libpython2.7.#{ext}",
            "-DPYTHON_INCLUDE_DIR=#{python_prefix}/include/python2.7",
            "../third_party/ycmd/cpp"
        system "make", "ycm_support_libs"
        cd "#{buildpath}"
        `rm -rf tmp_build`
        (prefix/"share/vim/vimfiles").install Dir["*"]

    end

end
