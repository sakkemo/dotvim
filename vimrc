execute pathogen#infect()

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
    "set makeprg=xelatex\ %
    set makeprg=pdflatex\ %:h/*.tex
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
nnoremap <leader>p :registers 012345<CR>:normal "p<left>
vnoremap <leader>p :registers 012345<CR>:normal "p<left>
