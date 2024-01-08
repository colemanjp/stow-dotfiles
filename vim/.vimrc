set nomodeline
set ignorecase
set smartcase
set clipboard+=unnamedplus

" convert tabs to spaces
" set tabstop=4 shiftwidth=4 expandtab

" let g:markdown_folding = 1

" Keep undo history across sessions, by storing it in a file.
set undolevels=1000
if has('persistent_undo')
    silent !mkdir -p ~/.local/share/vim/undo > /dev/null 2>&1
    set undodir=~/.local/share/vim/undo
    set undofile
endif

silent! colorscheme afterglow
silent! let g:afterglow_inherit_background=1

" Leader is \ by default
map <leader>D :put =strftime('# %a %Y-%m-%d %H:%M:%S%z')<CR>
