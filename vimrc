syntax enable

set tabstop=4      "width of a tab indent
set shiftwidth=4   "shift width is 4 spaces

set smarttab       "use shiftwidth instead of tabstop for inserting <TAB>s
set softtabstop=4  "backspace deletes this many space characters (treats as a tab)

set expandtab      "expand tabs into spaces
set smartindent    "smart indent = predictive indention based on a rough C syntax

set textwidth=78   " length to wrap lines to

filetype plugin indent on
syntax on

" use Ctrl-N/P to move buffers
nnoremap <silent> <C-N> :next<Enter>
nnoremap <silent> <C-P> :prev<Enter> 

" use Ctrl-Left/Right to move tabs
noremap <silent> <C-Left> :tabprev<Enter>
noremap <silent> <C-Right> :tabnext<Enter>
noremap <silent> <C-Up> :tabnew<Enter>
noremap <silent> <C-Down> :tabclose<Enter>

" confirmation save/discard on exit
set confirm

" enable tab line in tab-editing
set showtabline=1

" show command being entered on bottom line - right
set showcmd

" Automatically create folds on syntax
set foldmethod=syntax

" Space will toggle folds!
nnoremap <space> za

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
   set spl=en spell
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

" F5 -> make
map <F5> :make<CR>

" make html/css easier to deal with
autocmd FileType html,css set tabstop=2

" Return to last edit position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
