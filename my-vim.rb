require 'formula'

class MyVim < Formula

    #copy of statndard vim formula

    homepage "http://vim.org"
    url "ftp://ftp.vim.org/pub/vim/unix/vim-8.1.tar.bz2"
    version "8.1"

    depends_on "gettext"
    depends_on "lua"
    depends_on "perl"
    depends_on "ruby"

    def install
        ENV.prepend_path "PATH", Formula["python2"].opt_prefix/"bin"
        # vim doesn't require any Python package, unset PYTHONPATH.
        ENV.delete("PYTHONPATH")

        # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
        # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
        # system vimscript files. We specify the normal installation prefix
        # when calling "make install".
        # Homebrew will use the first suitable Perl & Ruby in your PATH if you
        # build from source. Please don't attempt to hardcode either.
        system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
            "--mandir=#{man}",
            "--enable-multibyte",
            "--with-tlib=ncurses",
            "--enable-cscope",
            "--enable-terminal",
            "--with-compiledby=Homebrew",
            "--enable-perlinterp",
            "--enable-rubyinterp",
            "--enable-pythoninterp",
            #"--enable-python3interp",
            "--enable-gui=no",
            "--without-x",
            "--enable-luainterp",
            "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
        system "make"
        # Parallel install could miss some symlinks
        # https://github.com/vim/vim/issues/1031
        ENV.deparallelize
        # If stripping the binaries is enabled, vim will segfault with
        # statically-linked interpreters like ruby
        # https://github.com/vim/vim/issues/114
        system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
        bin.install_symlink "vim" => "vi"
    end

end
