" This must be first, because it changes other options as side effect
set nocompatible

" Load the pathogen bundles in ~/.vim/bundle
" disable for now since I'm moving towards a slim vimrc
"call pathogen#helptags()
"call pathogen#infect()

" Use comma for mapleader instead of default \
let mapleader = ","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set nowrap          " don't wrap lines
set backspace=indent,eol,start
                    " allow backspacing over everything in insert mode
set smartindent     " smart indent = predictive indention based on a rough C syntax
set copyindent      " use the same characters for indentation as previous line

set ruler           " line/column in bottom-right
set number          " line numbers

set tabstop=4       " width of a tab indent
set softtabstop=4   " backspace deletes this many space characters (treats as a tab)
set shiftwidth=4    " shift width is 4 spaces
set smarttab        " use shiftwidth instead of tabstop for inserting <TAB>s
set expandtab       " expand tabs into spaces

set smartcase       " case-sensitive searching only when search string contains capitals
set textwidth=78    " length to wrap lines to

set incsearch       " search as you type
set nohlsearch      " don't highlight search terms

" Enable syntax highlighting
syntax enable
syntax on

set history=1000    " longer history than default (20)
set undolevels=1000 " lots of undo levels too
set title           " change the terminal's title
set visualbell      " don't beep
set noerrorbells    " don't beep

" using git is better for backups...
set nobackup        " 
set noswapfile      " don't need a .swp file during editing

set confirm         " confirmation save/discard on exit

"set mouse=a         " Mouse abilities

" in normal mode use ; not : for settingv
nnoremap ; :

set scrolloff=2     " keep cursor at least 2 lines from top/bottom sides
set sidescrolloff=2 " and 2 columns from left/right sides
set showtabline=1   " enable tab line only if there are multiple tabs to show
set showcmd         " show command being entered on bottom line - right

" file tab-completion does longest common prefix, then lists (like bash)
set wildmode=longest,list
" ignore some files in autocomplete
set wildignore=*.swp,*.bak,*.pyc,*.class

set foldmethod=syntax   " base folds on syntax
set nofoldenable    " don't fold by default


""" PER-FILETYPE SETTINGS

" enable file detection and syntax highlighting
filetype plugin indent on

autocmd FileType html,css set tabstop=2 sw=2 sts=2
autocmd FileType java compiler javac
autocmd FileType haskell compiler ghc
autocmd FileType python set foldmethod=expr
"autocmd FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class makeprg=python\ % foldmethod=indent


""" LEADER AND CUSTOM COMMANDS

" Use ,w to show toggle wrap
noremap <silent> <leader>w :set wrap!<Enter>
" Use ,I to show invisible characters
noremap <silent> <leader>i :set invlist<Enter>
" Use ,n to toggle line numbers
noremap <silent> <leader>n :set nonumber!<Enter>
" C-N and C-P next/previous buffer
nnoremap <silent> <C-N> :next<Enter>
nnoremap <silent> <C-P> :prev<Enter> 

" use - to take you back to the File Explorer
nnoremap <silent> - :Ex<Enter>

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
   set spl=en_us spell
   set nospell
endif

" Use ,s to toggle spelling
noremap <silent> <leader>s :set spell!<Enter>

" Use :w!! to save with sudo privs
nnoremap <silent> :w!! :w !sudo tee % 2>&1 >/dev/null<Enter>

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
   if g:paste_mode == 0
      set paste
      let g:paste_mode = 1
   else
      set nopaste
      let g:paste_mode = 0
   endif
   return
endfunc

" Paste Mode! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>
"}}}

" ctrl-space does auto completion
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" Lookup ctags "tags" file up the directory, until one is found
set tags=tags;/

" F5 does make
map <F5> :make<CR>

" Return to last edit position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" make % match tags like <tr><td><script> <?php etc
" TODO: load w/ pathogen
"source ~/.vim/ftplugin/matchit.vim

""" PLUGIN SETTINGS

" Quicker toggle-commenting
noremap <leader>/ :call NERDComment(0,"toggle")<cr>

au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null


""" PER-COMPUTER SETTINGS

" set haddock (haskell docs) browser and html dir
let g:haddock_browser = "/usr/bin/chromium"
let g:haddock_docdir = "/usr/share/doc/ghc/html/"

au BufReadCmd   *.jar,*.war,*.ear,*.sar,*.rar,*.par        call zip#Load(expand("<amatch>"))

set mls=5

vnoremap // y/<C-R>"<CR>
