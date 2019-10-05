"  Reloading .vimrc file
autocmd! BufWritePost .vimrc source %
autocmd! BufWritePost .vimrc call lightline#update()

" Automatic rezise buffers  when resizing window
autocmd! VimResized * wincmd =

call plug#begin('~/.vim/plugged')

Plug 'SirVer/ultisnips'         " Useful snippets
Plug 'lervag/vimtex'            " Latex compiler and syntax
Plug 'suy/vim-context-commentstring' " Know the type of file to comment
Plug 'tpope/vim-commentary'     " Comment lines more easely
Plug 'jiangmiao/auto-pairs'     " Auto complete brackets and parentheses
Plug 'justinmk/vim-sneak'       " Help with navegation
Plug 'chriskempson/base16-vim'  " Nice colorscheme
Plug 'itchyny/lightline.vim'    " Statusline
Plug 'harenome/vim-mipssyntax'  " Mips syntax for vim
Plug 'duggiefresh/vim-easydir'  " Make files and directories on vim
Plug 'tpope/vim-vinegar'        " File search
Plug 'wincent/loupe'            " Saw search commands more easy
Plug 'wincent/pinnacle'         " Control of the highlight groups
" Fuzzy finder, it need apt-get install ruby-dev
Plug 'wincent/command-t', {
  \   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
  \ }

call plug#end()

" ------------------------- Keybindings -------------------------
let mapleader = ","

" Plugin bindings
nnoremap <leader>c :VimtexCompile<CR>
nnoremap <leader>u :UltiSnipsEdit<CR>
nnoremap <leader>h :CommandTHelp<CR>

" Buffer related bindings
nnoremap <leader>d :bdelete<CR>
nnoremap <leader><leader> <C-^>
nnoremap <leader>q :quit<CR>

" Check if is need it to install: vim --version | grep clipboard 
" (+clipboard or +xterm_clipboard has to appear, otherwise install dependency)
" Requiered for ubuntu (vim-gtk/vim-gnome) or CentOs/Redhat (vim-X11)

" Copy to clipboard (",y") and paste to clipboard(",x")
vnoremap <leader>y "+y
vnoremap <leader>x "+d

" Better navigation between panes
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l

" Move code blocks more easily
vnoremap < <gv
vnoremap > >gv

" Consistent movement
noremap gh ^
noremap gl $
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" ------------------- Basic Vim configuration ----------------------

" Annoying things
set shortmess+=W      " Don't echo [w]/[written] when writing
set shortmess+=I      " Dont'n show Intro message of Vim
set shortmess+=T      " To big for the command line, put ...
set belloff=all       " Never ring the bell

" Highlight
syntax enable
set cursorline

" Lines configuration
set number          " Set current line number
set relativenumber  " Relactive numbers

if has('linebreak')
  set linebreak             " Wrap taking to account words
  let &showbreak='↳ '       " (U+21B3, UTF-8: E2 86 B3)
  set breakindent           " Indent wrapped lines to match start

  if exists('&breakindentopt')
    set breakindentopt=shift:2  " Emphasize broken lines by indenting them
  endif
endif

set list                              " Show whitespace
set listchars=nbsp:⦸                  " (U+29B8, UTF-8: E2 A6 B8)
set listchars+=tab:▷┅                 " (U+25B7, UTF-8: E2 96 B7) (U+2505, UTF-8: E2 94 85)
set listchars+=extends:»              " (U+00BB, UTF-8: C2 BB)
set listchars+=precedes:«             " (U+00AB, UTF-8: C2 AB)
set listchars+=trail:•                " (U+2022, UTF-8: E2 80 A2)

" Puts vertical windows to right, instead of left and down instead of up
set splitbelow splitright

set backspace=indent,eol,start
set hidden " Allow you to hide buffers with unsaved changes
set autoread " When a file is change outside the editor, vim try to read it again

" Tabs ('\t') configurations: Soft tabs, 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2    " How much spaces to take when << or >> is used on Normal Mode
set shiftround      " When there are multiple lines and you use < or >
set expandtab

" Wildmenu configuration
set wildmenu " Making a suggestion menu in searches and autocompletition on Console Mode
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
set wildignore+=.DS_Store,*.pdf,*/project/*,*/target/*
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.class

" Nice looking colors on terminal
if (has("termguicolors"))
  set termguicolors
endif

" Folds configurations
set foldmethod=syntax         " Not as cool as syntax, but faster
set foldlevelstart=1          " Start unfolded
set viewoptions=folds         " Remember folds on files
set foldtext=FoldText()       " How folds look like
set fillchars+=fold:·         " (U+00B7, UTF-8: C2 B7)

function! FoldText() abort
  let s:middot='·'
  let s:raquo='»'
  let s:small_l='ℓ'

  let l:lines='[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
  let l:first=substitute(getline(v:foldstart), '\v *', '', '')
  let l:dashes=substitute(v:folddashes, '-', s:middot, 'g')
  return s:raquo . s:middot . s:middot . l:lines . l:dashes . ': ' . l:first
endfunction

" ------------------------ Plugins Configurations -----------------------

" --------------------- Ultisnips configuration ---------------------
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetsDir="~/Dotfiles/vim/vimSnips"
let g:UltiSnipsSnippetDirectories=[$HOME.'/Dotfiles/vim/vimSnips']

" Edit vertical Ultisnips edition
let g:UltiSnipsEditSplit="vertical"

" --------------------- Vimtex cofiguration -----------------------
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

" Symbols and special characters view nice or invisible in .tex files
set conceallevel=1
let g:tex_conceal='abdmg'

" Deleting all the temp files that latexmk compiler make
autocmd VimLeave *.tex !latexmk -c %

" ---------------- CommandT config ------------------------------
let g:CommandTHighlightColor='CursorLine'

" ---------------- Vinegar config ------------------------------
let g:netrw_liststyle = 3

" ------------------ LightLine config ------------------------------
set laststatus=2
set noshowmode
let g:lightline = {
  \   'colorscheme': 'fredoLightline',
  \   'separator': { 'left': '', 'right': '' },
  \   'subseparator': { 'left': '', 'right': '' },
  \   'active': {
  \     'right': [ ['percent'], ['lineinfo'] , ['filetype'] ],
  \     'left': [ [ 'mode', 'paste' ],
  \       [ 'myReadonly', 'relativepath', 'myModified'] ]
  \   },
  \   'inactive': {
  \     'left': [ [ 'relativepath' ] ],
  \     'right': [ [ 'filetype' ] ]
  \   },
  \   'component': {
  \     'lineinfo': 'ℓ %3l:%-2v'
  \   },
  \   'component_function': {
  \     'myModified': 'LightlineModified',
  \     'myReadonly': 'LightlineReadonly'
  \   }
  \ }

function! LightlineModified()
  return &modifiable && &modified ? '✘' : ''
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

" ------------------ Loupe config ------------------------------
function! s:SetUpLoupeHighlight()
  execute 'highlight! QuickFixLine ' . pinnacle#extract_highlight('PmenuSel')

  highlight! clear Search
  execute 'highlight! Search ' . pinnacle#embolden('Underlined')
endfunction

autocmd ColorScheme * call s:SetUpLoupeHighlight()

" ------------------ MIPS syntax config ------------------------------
autocmd BufNewFile,BufRead *.s set syntax=mips

" ------------------ Sneak config ------------------------------
highlight Sneak guifg=black guibg=salmon ctermfg=black ctermbg=red

" ------------------ base16 colorscheme config ------------------------------
function! s:base16_customize() abort
  call Base16hi("Comment", g:base16_gui03, '', '', '', "italic", "")
endfunction

" Colorsheme for Terminal (Check https://github.com/chriskempson/base16-shell)
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
  call s:base16_customize()
endif

" Delete background color of the line that show the numbers
highlight LineNr guibg=NONE
set highlight+=N:DiffText     " Make current line number stand out a little

