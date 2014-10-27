require 'formula'

class Vim74 < Formula

    homepage "http://vim.org"
    url "ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2"
    version "7.4"

    def install
        python_prefix = `#{ENV['HOME']}/packages/bin/python2 -c "import sys; print sys.prefix"`.chomp
        ohai "Python prefix: ", python_prefix

        ENV["vi_cv_path_python"] = "#{python_prefix}/bin/python2"

        system "./configure",
            "--prefix=#{prefix}",
            "--with-python-config-dir=#{python_prefix}/lib/python2.7/config",
            "--enable-pythoninterp=yes",
            "--with-features=huge"

        system "make"
        system "make", "install"

    end

end
