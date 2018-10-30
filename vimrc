""" nocompatible, syntax, ftplugin
set nocompatible

filetype plugin indent on
if !exists("g:syntax_on")
    syntax enable
endif

scriptencoding utf-8
runtime macros/matchit.vim

""" fast editing of the .vimrc
let mapleader=","
let maplocalleader="ä"
map <leader>e :e! $MYVIMRC<cr>
autocmd! BufWritePost $MYVIMRC source %

""" hidden, completion
set hidden

set wildmenu
if has('&wildignorecase')
    set wildignorecase
end
set wildmode=list:longest,full

set completeopt=menu,longest
set isfname-==

""" ruler, showcmd, hlsearch, laststatus
set showcmd
set hlsearch
set ruler
set laststatus=2
"set nomodeline

""" case, backspace, indent
set ignorecase
set smartcase

set backspace=indent,eol,start
set nostartofline

set autoindent
set shiftwidth=4
set softtabstop=4
set expandtab

""" usability preferences
set confirm
set visualbell
set t_vb=
set mouse=a
set notimeout ttimeout ttimeoutlen=200

"undo
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

""" mappings
nnoremap <C-L> :nohl<CR><C-L>
nnoremap <Leader>cd :cd %:h
nnoremap <Leader>l :ls<CR>:b<space>
nnoremap <Leader>cc :g#/\*#.,/\*\/$/d<CR>:%s/);/){\r}<CR>:g/#/d<CR>
nnoremap <leader>p :registers 012345<CR>:normal "p<left>
vnoremap <leader>p :registers 012345<CR>:normal "p<left>
nnoremap <leader>ge :call setline('.', systemlist('curl -s ' .  shellescape(getline('.'))))<CR>

""" GUI etc
if has("gui_running")
    set guioptions=acegiLt
    set guifont=Fira\ Mono:h11
    "set guifont=Fira\ Mono\ 11
end
" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

set number

set statusline=%<\ %f\ %m\ [%{&ff},%{&ft}%{&eol?'':','}%#Error#%{&eol?'':'noeol'}%*]%w%=\ L:\ \%l\/\%L\ C:\ \%c\ 

set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

try
    colorscheme apprentice
catch
    colorscheme desert
endtry

if (exists('g:colors_name') && colors_name=~"jellybeans")
    hi Search guifg=#F0E4A0 guibg=#302820
    hi clear SpellBad
    hi SpellBad term=reverse cterm=underline ctermbg=88 gui=undercurl guisp=Red 
    "guibg=#902020 
end

""" functions
function! LongestLine()
    let lines = map(getline(1, '$'), 'len(v:val)')
    return index(lines, max(lines))+1
endfunction
command! Longest exec LongestLine()

""" use venv python
" VIRTUALENV setup
:python << EOF
import os 
virtualenv = os.environ.get('VIRTUAL_ENV') 
if virtualenv: 
  activate_this = os.path.join(virtualenv, 'bin', 'activate_this.py') 
  if os.path.exists(activate_this): 
    execfile(activate_this, dict(__file__=activate_this)) 
EOF

"" vim:fdm=expr:fdl=0
"" vim:fde=getline(v\:lnum)=~'^""'?'>'.(matchend(getline(v\:lnum),'""*')-2)\:'='
