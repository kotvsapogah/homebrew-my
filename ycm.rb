require 'formula'

class Ycm < Formula
    homepage "https://github.com/Valloric/YouCompleteMe"
    url "https://github.com/Valloric/YouCompleteMe", :using => :git
    version "3.9.0"

    #depends_on "kotvsapogah/my/llvm"
    #depends_on "llvm38"
    #depends_on "cmake" => :build
    depends_on "python"

    def install
        #for dir in %W[
            #autoload doc plugin python
            #colors ftdetect ftplugin indent compiler after]
            #system "mkdir", "-p", "#{HOMEBREW_PREFIX}/share/vim/vimfiles/#{dir}"
        #end

        os = `uname -s`.chomp
        if os == "Darwin"
            ext = "dylib"
        elsif os == "Linux"
            ext = "so"
        end

        python = "#{HOMEBREW_PREFIX}/bin/python"
        cmake = "#{HOMEBREW_PREFIX}/bin/cmake"
        #python = "/usr/bin/python2"
        python_prefix = `#{python} -c "import sys; print sys.prefix"`.chomp
        python_includedir = `#{python} -c "from distutils import sysconfig; print sysconfig.get_python_inc()"`.chomp
        python_libdir = `#{python} -c "from distutils import sysconfig; print sysconfig.get_config_var('LIBDIR')"`.chomp
        python_version = `#{python} -c "from distutils import sysconfig; print sysconfig.get_config_var('VERSION')"`.chomp
        python_library = "#{python_libdir}/libpython#{python_version}.#{ext}" 
        ohai "Python prefix: ", python_prefix
        ohai "Python include: ", python_includedir
        ohai "Python library: ", python_library

        #clang_path = Formula["llvm38"].opt_prefix/"lib/llvm-3.8/lib/libclang.#{ext}"
        
        #clang_path = var/"libclang.#{ext}"
        clang_path = opt/"llvm"

        args = [
            "-DPYTHON_EXECUTABLE=#{python}",
            "-DPYTHON_LIBRARY=#{python_library}",
            "-DPYTHON_INCLUDE_DIR=#{python_includedir}",
            "-DPATH_TO_LLVM_ROOT=#{clang_path}"
            #"-DEXTERNAL_LIBCLANG_PATH=#{clang_path}",
            #"-DUSE_SYSTEM_LIBCLANG=ON"
        ]

        mktemp do
            system "#{cmake}", "-G", "Unix Makefiles", var/"YouCompleteMe/third_party/ycmd/cpp", *args
            system "#{cmake}", "--build", ".", "--target", "ycm_core"
        end

        (prefix/"ycm").install Dir["*"]

    end

end
