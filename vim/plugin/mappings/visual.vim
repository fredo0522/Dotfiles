"
" Visual bindings
"

" Move between windows
xnoremap <C-h> <C-w>h
xnoremap <C-j> <C-w>j
xnoremap <C-k> <C-w>k
xnoremap <C-l> <C-w>l

" Move code blocks more easily
vnoremap < <gv
vnoremap > >gv

" Check if is need it to install: vim --version | grep clipboard
" requiered for Ubuntu (vim-gtk/vim-gnome), CentOs/Redhat (vim-X11) and Arch (gvim)
vnoremap <leader>y "+y
vnoremap <leader>d "+d

