syntax enable

let mapleader = ","

" longer history than default (20)
set history=100

set tabstop=4      "width of a tab indent
set shiftwidth=4   "shift width is 4 spaces
set smarttab       "use shiftwidth instead of tabstop for inserting <TAB>s

set softtabstop=4  "backspace deletes this many space characters (treats as a tab)

set expandtab      "expand tabs into spaces
set smartindent    "smart indent = predictive indention based on a rough C syntax

set textwidth=78   " length to wrap lines to

" enable file detection and syntax highlighting
filetype plugin indent on
syntax on

" line/column in bottom-right
set ruler

" Use ,I to show invisible characters
noremap <silent> <leader>I :set invlist<Enter>

" easy next/previous buffer
nnoremap <silent> <C-N> :next<Enter>
nnoremap <silent> <C-P> :prev<Enter> 

" use Ctrl-Left/Right to move tabs
noremap <silent> <C-Left> :tabprev<Enter>
noremap <silent> <C-Right> :tabnext<Enter>
noremap <silent> <C-Up> :tabnew<Enter>
noremap <silent> <C-Down> :tabclose<Enter>

" use - to take you back to the File Explorer
noremap <silent> - :Ex<Enter>

" search as you type
set incsearch

" case-sensitive searching only when search string contains capitals
set smartcase

" keep 2 lines and 2 cols of context around the cursor
set scrolloff=2
set sidescrolloff=2

" file tab-completion does longest common prefix, then lists (like bash)
set wildmode=longest,list

" confirmation save/discard on exit
set confirm

" enable tab line only if there are at least 2 tabs to show
set showtabline=1

" show command being entered on bottom line - right
set showcmd

" Automatically create folds on syntax
set foldmethod=syntax
set nofoldenable        "don't fold by default

" Space will toggle folds!
nnoremap <space> za

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
   set spl=en_us spell
   set nospell
endif

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

" Mouse abilities
"set mouse=a

" line numbers
set number

" Lookup ctags "tags" file up the directory, until one is found
set tags=tags;/

" F5 does make
map <F5> :make<CR>

" make html/css easier to deal with
autocmd FileType html,css set tabstop=2

" Return to last edit position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" make % match tags like <tr><td><script> <?php etc
source ~/.vim/ftplugin/matchit.vim

" language-specific files
autocmd FileType java :compiler javac
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class makeprg=python\ % foldmethod=indent
autocmd FileType html,css set tabstop=2 sw=2 sts=2

" ghc on haskell files
au Bufenter *.hs compiler ghc
