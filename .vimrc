call plug#begin()
Plug 'iCyMind/NeoSolarized'
Plug 'mbbill/undotree'
Plug 'tomtom/tcomment_vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
endif

nnoremap <silent> gd :LspDefinition<CR>
"nnoremap <buffer> gd <plug>(lsp-definition)
"nnoremap <buffer> ,n <plug>(lsp-next-error)
"nnoremap <buffer> ,p <plug>(lsp-previous-error)
autocmd BufWritePre *.go :LspDocumentFormatSync
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_signs_enabled = 1
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': '‼'}

set fileencodings=utf-8
syn on
filetype on
filetype indent on
filetype plugin on
set termguicolors
set background=light
colorscheme NeoSolarized
set ai
":set hidden means that the buffer of the old file will only be hidden when you switch to the new file. When you switch back, you still have your undo history.
set hidden

" gvim
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

set clipboard+=unnamedplus

set ignorecase
set smartcase
set hlsearch
set incsearch

set foldmethod=indent
set foldlevel=99

inoremap jj <ESC>
nnoremap <F5> :UndotreeToggle<CR>
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

let g:fzf_buffers_jump = 1
