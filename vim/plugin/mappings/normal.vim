"
" Normal bindings
"

" NERDTree toggle
nnoremap <silent> - :NERDTreeToggle<CR>

" Change what selected on '*' command (if you want to change a word in multiple lines)
" press 'n' then '.' after the first iteration. (mnemonic of 'c'hange)
nnoremap c* *Ncgn

" Consistent movement
noremap gh ^
noremap gl $
noremap j gj
noremap k gk
noremap gj j
noremap gk k

" Toggle folds (if not possible use the default behavior of <tab>)
nnoremap <silent> <Tab> @=(foldlevel('.')?'za':"\<Tab>")<CR>

