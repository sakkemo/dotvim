" Features & plugin list {{{1
" Fast editing of the .vimrc
let mapleader=","
let maplocalleader="ä"
map <leader>e :e! ~/.vimrc<cr>
autocmd! BufWritePost .vimrc source %

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

filetype plugin indent on

" Enable syntax highlighting
syntax enable

"------------------------------------------------------------
" Vim-addon-manager {{{1
        fun! EnsureVamIsOnDisk(vam_install_path)
          " windows users may want to use http://mawercer.de/~marc/vam/index.php
          " to fetch VAM, VAM-known-repositories and the listed plugins
          " without having to install curl, 7-zip and git tools first
          " -> BUG [4] (git-less installation)
          let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
          if eval(is_installed_c)
            return 1
          else
            if 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
              " I'm sorry having to add this reminder. Eventually it'll pay off.
              call confirm("Remind yourself that most plugins ship with ".
                          \"documentation (README*, doc/*.txt). It is your ".
                          \"first source of knowledge. If you can't find ".
                          \"the info you're looking for in reasonable ".
                          \"time ask maintainers to improve documentation")
              call mkdir(a:vam_install_path, 'p')
              execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
              " VAM runs helptags automatically when you install or update 
              " plugins
              exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
            endif
            return eval(is_installed_c)
          endif
        endf

        fun! SetupVAM()
          " Set advanced options like this:
          " let g:vim_addon_manager = {}
          " let g:vim_addon_manager['key'] = value
          "     Pipe all output into a buffer which gets written to disk
          " let g:vim_addon_manager['log_to_buf'] =1

          " Example: drop git sources unless git is in PATH. Same plugins can
          " be installed from www.vim.org. Lookup MergeSources to get more control
          " let g:vim_addon_manager['drop_git_sources'] = !executable('git')
          " let g:vim_addon_manager.debug_activation = 1

          " VAM install location:
          let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
          if !EnsureVamIsOnDisk(vam_install_path)
            echohl ErrorMsg
            echomsg "No VAM found!"
            echohl NONE
            return
          endif
          exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

          " Tell VAM which plugins to fetch & load:
          call vam#ActivateAddons(['jellybeans', 'Vim-R-plugin', 'Screen_vim__gnu_screentmux'], {'auto_install' : 0})
          " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

          " Addons are put into vam_install_path/plugin-name directory
          " unless those directories exist. Then they are activated.
          " Activating means adding addon dirs to rtp and do some additional
          " magic

          " How to find addon names?
          " - look up source from pool
          " - (<c-x><c-p> complete plugin names):
          " You can use name rewritings to point to sources:
          "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
          "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
          " Also see section "2.2. names of addons and addon sources" in VAM's documentation
        endfun
        call SetupVAM()
        " experimental [E1]: load plugins lazily depending on filetype, See
        " NOTES
        " experimental [E2]: run after gui has been started (gvim) [3]
        " option1:  au VimEnter * call SetupVAM()
        " option2:  au GUIEnter * call SetupVAM()
        " See BUGS sections below [*]
        " Vim 7.0 users see BUGS section [3]
"------------------------------------------------------------
" Must have options {{{1

set hidden

set wildmenu

" Show partial commands in the last line of the screen
set showcmd

set hlsearch

set nomodeline


"------------------------------------------------------------
" Usability options {{{1

set ignorecase
set smartcase

set backspace=indent,eol,start

set autoindent

set nostartofline

set ruler

set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab


"------------------------------------------------------------
" Mappings {{{1

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <F5> :!clear<CR>:wa\|:make<CR>
nnoremap <Leader>cd :let @+=expand("%:p:h")<CR>
nnoremap <Leader>l :ls<CR>:b<space>

"nnoremap <Leader>cc :%s/\/\*\_.\{-}\*\///g<CR>:%s/);/){\r\r}<CR>
nnoremap <Leader>cc :g#/\*#.,/\*\/$/d<CR>:%s/);/){\r}<CR>:g/#/d<CR>

"------------------------------------------------------------
" Make {{{1
"
autocmd FileType cpp call <SID>cppstuff()
" C++-special hook"{{{
function! <SID>cppstuff()
    if filereadable("Makefile")
        set makeprg=make
    else
        set makeprg=g++\ -std=c++0x\ -Wall\ -Wextra\ -pedantic\ -g\ -D_GLIBCXX_DEBUG\ -o\ main\ %:h/*.cc
    endif
    nmap <M-a> <Esc>:!ctags *.cpp *.h<CR>
    inoremap ' ->
    nnoremap <F6> :!./main<CR>
endfunction

" LaTeX-special hook"{{{
autocmd FileType tex call <SID>latexstuff()
function! <SID>latexstuff()
    set makeprg=xelatex\ %
    "set makeprg=pdflatex\ %:h/*.tex
    nnoremap <F5> :!clear<CR>:w\|:make<CR><CR>
    nnoremap <F6> :execute "!zathura " . expand("%:r") . ".pdf &"<CR>
endfunction
"}}}"}}}"}}}
let vimrplugin_screenplugin = 1
let vimrplugin_only_in_tmux = 1
" Look & folding {{{1

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

set number

set foldmethod=marker

colorscheme jellybeans
"------------------------------------------------------------
"
"
