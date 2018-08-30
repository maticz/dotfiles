"execute pathogen#infect()
call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'sjl/gundo.vim'
Plug 'tomtom/tcomment_vim'
Plug 'neomake/neomake'
" Use without --go-completer flag to force YCM to use omnifunc set by vim-go.
" Vim-go is usually faster to add support for new Go versions as was the case
" with a switch to github.com/mdempsky/gocode to support Go 1.11.
" For more info see: https://github.com/fatih/vim-go/issues/390
Plug 'Valloric/YouCompleteMe', { 'do': 'python3 ./install.py' }
Plug 'fatih/vim-go', { 'tag': '*', 'do': ':GoInstallBinaries' }
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

set fileencodings=utf-8
syn on
filetype on
filetype indent on
filetype plugin on
set background=light
colorscheme solarized
set ai
":set hidden means that the buffer of the old file will only be hidden when you switch to the new file. When you switch back, you still have your undo history.
set hidden

if has('mac')
    set clipboard=unnamed
elseif has('unix')
    set clipboard=unnamedplus
endif

set ignorecase
set smartcase
set hlsearch
set incsearch

set foldmethod=indent
set foldlevel=99

inoremap jj <ESC>
nnoremap <F5> :GundoToggle<CR>
nnoremap <C-P> :Files<CR>
nnoremap <F2> :buffers<CR>:buffer<Space>

"These are to cancel the default behavior of d, D, c, C
"  to put the text they delete in the default register.
"  Note that this means e.g. "ad won't copy the text into
"  register a anymore.  You have to explicitly yank it.
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

" Always show status line
set laststatus=2

" Status line settings
" Filename
set statusline=%f
" vim-go
set statusline+=%#goStatuslineColor#
set statusline+=%{go#statusline#Show()}
set statusline+=%*
" Switch to the right side
:set statusline+=%=
" Current line
set statusline+=%l
set statusline+=/
" Total lines
set statusline+=%L
set statusline+=,
" Column number
set statusline+=%c
set statusline+=-
" Virtual column number
set statusline+=%v
set statusline+=\ 
" Percentage through file of displayed window.
set statusline+=%P

"This allows you to use the < and > keys from visual mode to block indent/unindent regions
au BufRead,BufNewFile *.h,*.c,*.cpp,*.py,*pyw,*html,*css,*.less,*js set shiftwidth=4
"A four-space tab indent width is the prefered coding style for Python.
au BufRead,BufNewFile *.h,*.c,*.cpp,*py,*pyw,*html,*css,*.less,*js set tabstop=4
"People like using real tab character instead of spaces because it makes it easier when pressing BACKSPACE or DELETE, since if the indent is using spaces it will take 4 keystrokes to delete the indent. Using this setting, however, makes VIM see multiple space characters as tabstops, and so <BS> does the right thing and will delete four spaces (assuming 4 is your setting).
au BufRead,BufNewFile *.h,*.c,*.cpp,*py,*pyw,*html,*css,*less,*js set softtabstop=4
"Insert spaces instead of <TAB> character when the <TAB> key is pressed
au BufRead,BufNewFile *.h,*.c,*.cpp,*.py,*.pyw,*html,*css,*less,*js set expandtab

au BufRead,BufNewFile *.php,*.phtml set tabstop=4
au BufRead,BufNewFile *.php,*.phtml set shiftwidth=4

au BufNewFile,BufRead *.less set filetype=less

"Plugin settings
autocmd! BufWritePost,BufRead * Neomake
let g:neomake_open_list = 2
let g:neomake_go_enabled_makers = ['go', 'govet']
let g:neomake_python_flake8_maker = {'args': ['--ignore=E126,E127,W191', '--max-line-length=120']}

" let g:ale_lint_on_enter = 1
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_open_list = 1
" let g:ale_linters = {
" \   'go': ['gofmt', 'go vet', 'go build'],
" \}

let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_add_preview_to_completeopt=0
set completeopt-=preview

let g:fzf_buffers_jump = 1
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
