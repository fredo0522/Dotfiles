"
" statusline functions
"
" (https://github.com/wincent/wincent/blob/master/roles/dotfiles/files/.vim/autoload/wincent/statusline.vim)
scriptencoding utf-8

function! statusline#active()
    try
        call pinnacle#highlight({})
        return 1
    catch /E117/
        " Pinnacle probably isn't loaded
        return 0
    endtry
endfunction

function! statusline#gutterpadding() abort
    let l:signcolumn=0
    if exists('+signcolumn')
        if &signcolumn == 'yes'
            let l:signcolumn=2
        elseif &signcolumn == 'auto'
            if exists('*execute')
                let l:signs=execute('sign place buffer=' .bufnr('$'))
            else
                let l:signs=''
                silent! redir => l:signs
                silent execute 'sign place buffer=' . bufnr('$')
                redir END
            end
            if match(l:signs, 'line=') != -1
                let l:signcolumn=2
            endif
        endif
    endif

    let l:minwidth=2
    let l:gutterWidth=max([strlen(line('$')) + 1, &numberwidth, l:minwidth]) + l:signcolumn
    let l:padding=repeat(' ', l:gutterWidth - 1)
    return l:padding
endfunction

function! statusline#fileprefix() abort
    let l:basename=expand('%:h')
    if l:basename ==# '' || l:basename ==# '.'
        return ''
    elseif has('modify_fname')
        " Make sure we show $HOME as ~.
        let l:basename =  substitute(fnamemodify(l:basename, ':~:.'), '/$', '', '') . '/'
    else
        " Make sure we show $HOME as ~.
        let l:basename =  substitute(l:basename . '/', '\C^' . $HOME, '~', '')
    endif

    return basename
endfunction

function! statusline#ft() abort
    if strlen(&ft)
        return ',' . &ft
    else
        return ''
    endif
endfunction

function! statusline#fenc() abort
    if strlen(&fenc) && &fenc !=# 'utf-8'
        return ',' . &fenc
    else
        return ''
    endif
endfunction

function! statusline#lhs() abort
    let l:line=statusline#gutterpadding()
    " HEAVY BALLOT X - Unicode: U+2718, UTF-8: E2 9C 98
    let l:line.=&modified ? '✘ ' : '  '
    return l:line
endfunction

function! statusline#rhs() abort
    let l:rhs=' '
    if winwidth(0) > 80
        let l:column=virtcol('.')
        let l:width=virtcol('$')
        let l:line=line('.')
        let l:height=line('$')

        " Add padding to stop rhs from changing too much as we move the cursor.
        let l:padding=len(l:height) - len(l:line)
        if (l:padding)
            let l:rhs.=repeat(' ', l:padding)
        endif

        let l:rhs.='ℓ ' " (Literal, \u2113 "SCRIPT SMALL L").
        let l:rhs.=l:line
        let l:rhs.=':'
        let l:rhs.=l:column
        let l:rhs.=' '

        " Add padding to stop rhs from changing too much as we move the cursor.
        if len(l:column) < 2
            let l:rhs.=' '
        endif
        if len(l:width) < 2
            let l:rhs.=' '
        endif
    endif
    return l:rhs
endfunction

let s:default_lhs_color='Function'
let s:async_lhs_color='Constant'
let s:modified_lhs_color='String'
let s:current_statusline_status_highlight=s:default_lhs_color
let s:async=0

function! statusline#check_modified() abort
    if &modified && s:current_statusline_status_highlight != s:modified_lhs_color
        let s:current_statusline_status_highlight=s:modified_lhs_color
        call statusline#update_highlight()
    elseif !&modified
        if s:async && s:current_statusline_status_highlight != s:async_lhs_color
            let s:current_statusline_status_highlight=s:async_lhs_color
            call statusline#update_highlight()
        elseif !s:async && s:current_statusline_status_highlight != s:default_lhs_color
            let s:current_statusline_status_highlight=s:default_lhs_color
            call statusline#update_highlight()
        endif
    endif
endfunction

function! statusline#update_highlight() abort
    if !statusline#active()
        return
    endif

    " Update StatusLine to use italics (used for filetype).
    let l:highlight=pinnacle#italicize('StatusLineNC')
    execute 'highlight User1 ' . l:highlight

    " Update MatchParen to use italics (used for blurred statuslines).
    let l:highlight=pinnacle#italicize('MatchParen')
    execute 'highlight User2 ' . l:highlight

    " StatusLine + bold (used for file names).
    let l:highlight=pinnacle#embolden('StatusLine')
    execute 'highlight User3 ' . l:highlight

    " Inverted Error styling, for left-hand side 'Powerline' triangle.
    let l:fg=pinnacle#extract_fg(s:current_statusline_status_highlight)
    let l:bg=pinnacle#extract_bg('StatusLine')
    execute 'highlight User4 ' . pinnacle#highlight({'bg': l:bg, 'fg': l:fg})

    " And opposite for the buffer number area.
    execute 'highlight User7 ' .
            \ pinnacle#highlight({
            \   'bg': l:fg,
            \   'fg': pinnacle#extract_bg('Normal'),
            \   'term': 'bold'
            \ })

    " Right-hand side section.
    let l:fg=pinnacle#extract_fg('Cursor')
    let l:bg=pinnacle#extract_fg('User3')
    execute 'highlight User5 ' .
            \ pinnacle#highlight({
            \   'bg': l:fg,
            \   'fg': l:bg,
            \   'term': 'bold'
            \ })

    " Right-hand side section + italic (used for %).
    execute 'highlight User6 ' .
            \ pinnacle#highlight({
            \   'bg': l:fg,
            \   'fg': l:bg,
            \   'term': 'bold,italic'
            \ })

    highlight clear StatusLineNC
    highlight! link StatusLineNC User1
endfunction

let g:CurrentQuickfixStatusline =
      \ '%7*'
      \ . '%{statusline#lhs()}'
      \ . '%*'
      \ . '%4*'
      \ . ''
      \ . '\ '
      \ . '%*'
      \ . '%3*'
      \ . '%q'
      \ . '\ '
      \ . '%{get(w:,\"quickfix_title\",\"\")}'
      \ . '%*'
      \ . '%<'
      \ . '\ '
      \ . '%='
      \ . '\ '
      \ . '%5*'
      \ . '%{statusline#rhs()}'
      \ . '%*'

function! statusline#blur_statusline() abort
    " Default blurred statusline (buffer number: filename).
    let l:blurred='%{statusline#lhs()}'
    let l:blurred.='\ ' " space
    let l:blurred.='\ ' " space
    let l:blurred.='\ ' " space
    let l:blurred.='\ ' " space
    let l:blurred.='%<' " truncation point
    let l:blurred.='%f' " filename
    let l:blurred.='%=' " split left/right halves (makes background cover whole)
    call s:update_statusline(l:blurred, 'blur')
endfunction

function! statusline#focus_statusline() abort
    " `setlocal statusline=` will revert to global 'statusline' setting.
    call s:update_statusline('', 'focus')
endfunction

function! s:update_statusline(default, action) abort
    let l:statusline = s:get_custom_statusline(a:action)
    if type(l:statusline) == type('')
        " Apply custom statusline.
        execute 'setlocal statusline=' . l:statusline
    elseif l:statusline == 0
        return
    else
        " if can't apply custom, use default
        execute 'setlocal statusline=' . a:default
    endif
endfunction

function! s:get_custom_statusline(action) abort
    if &ft ==# 'diff' && exists('t:diffpanel') && t:diffpanel.bufname ==# bufname('%')
        return 'Undotree\ preview' " Less ugly, and nothing really useful to show.
    elseif &ft ==# 'undotree'
        return 0 " Don't override; undotree does its own thing.
    elseif &ft ==# 'qf'
        if a:action ==# 'blur'
            return
                \ '%{statusline#gutterpadding()}'
                \ . '\ '
                \ . '\ '
                \ . '\ '
                \ . '\ '
                \ . '%<'
                \ . '%q'
                \ . '\ '
                \ . '%{get(w:,\"quickfix_title\",\"\")}'
                \ . '%='
        else
            return g:CurrentQuickfixStatusline
        endif
    endif

    return 1 " Use default.
endfunction

"
"  Making statusline
"

" (https://github.com/wincent/wincent/blob/76690087d69730da681612785e2722904ddfc562/roles/dotfiles/files/.vim/plugin/statusline.vim)
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=%7*                                 " Switch to User7 highlight group
set statusline+=%{statusline#lhs()}
set statusline+=%*                                 " Reset highlight group.
set statusline+=%4*                                " Switch to User4 highlight group (Powerline arrow).
set statusline+=                                  " Powerline arrow.
set statusline+=%*                                 " Reset highlight group.
set statusline+=\                                  " Space.
set statusline+=%<                                 " Truncation point, if not enough width available.
set statusline+=%{statusline#fileprefix()}         " Relative path to file's directory.
set statusline+=%3*                                " Switch to User3 highlight group (bold).
set statusline+=%t                                 " Filename.
set statusline+=%*                                 " Reset highlight group.
set statusline+=\                                  " Space.
set statusline+=%1*                                " Switch to User1 highlight group (italics).

" Needs to be all on one line:
"   %(                           Start item group.
"   [                            Left bracket (literal).
"   %R                           Read-only flag: ,RO or nothing.
"   %{statusline#ft()}   Filetype (not using %Y because I don't want caps).
"   %{statusline#fenc()} File-encoding if not UTF-8.
"   ]                            Right bracket (literal).
"   %)                           End item group.
set statusline+=%([%R%{statusline#ft()}%{statusline#fenc()}]%)

set statusline+=%*              " Reset highlight group.
set statusline+=%=              " Split point for left and right groups.

set statusline+=\               " Space.
set statusline+=%3*             " Switch to User5 highlight group.
set statusline+=%{statusline#rhs()}
set statusline+=\               " Space.
set statusline+=%p%%            " File porcentage
set statusline+=\               " Space.
set statusline+=%*              " Reset highlight group.
