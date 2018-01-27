" Set encoding to utf8
set encoding=utf-8

" Enable syntax highlighting
syntax on

" Show row numbers
set number

" Enable auto indent
set autoindent

" Its often useful to 'set paste' so that the autoindent/syntax doesn't interfere
set paste

" Jumps automatically to during search
set incsearch

" Disable case sensitive search
set ignorecase

" Highlighting search results
set hlsearch

" Insert spaces instead of tabs
set expandtab

" Set the indent to 4 spaces
set tabstop=4
set shiftwidth=4

" Set how unvisibile chars made be visible
set listchars=tab:$-,trail:-

" set visbiblity of unvisbile chars which determinate in list chars
set list

" Enable filetype plugin
filetype plugin on


" Enable automatic toggling between line number modes
set number relativenumber

augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


" Use system clipboard if available
if has("clipboard")
    set clipboard=unnamedplus
endif


" ===============
" Keybindings
" ===============

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" ===============
" Status line
" ===============
highlight StatusLine cterm=none ctermbg=239 ctermfg=251 guibg=#4e4e4e guifg=#c6c6c6
"highlight StatusLineNC ctermbg=239 ctermfg=251
execute 'highlight! User5 ctermfg=red ctermbg=yellow'

set laststatus=2
set statusline=\ 
set statusline+=hello
set statusline+=\ world


