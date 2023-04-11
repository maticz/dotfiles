call plug#begin()
Plug 'iCyMind/NeoSolarized'
Plug 'mbbill/undotree'
Plug 'tomtom/tcomment_vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-fugitive'
Plug 'puremourning/vimspector'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
", {'branch': '0.5-compat', 'do': ':TSUpdate'}
call plug#end()

let g:vimspector_enable_mappings = 'HUMAN'

set completeopt=menuone,noselect

lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
EOF

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  --buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
-- local servers = { "gopls", "pylsp" }
local servers = { "gopls", "pyright" , "ccls" , "tsserver"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

require "lspconfig".efm.setup {
    init_options = {documentFormatting = true},
    filetypes = {'python'},
    settings = {
        rootMarkers = {".git/"},
        languages = {
            python = {
                {formatCommand = "black --quiet -", formatStdin = true}
            }
        }
    }
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "go", "python", "bash", "html", "javascript", "json", "make", "c", "lua", "rust" },
  highlight = {
    enable = true,
  },
}
EOF

" timeout at 5s because it takes a bit longer at the start
" while lsp builds its cache.
autocmd BufWritePre *.go lua vim.lsp.buf.format({ async = false })
autocmd BufWritePre *.py lua vim.lsp.buf.format({ async = false })
" neovim 0.8+
" vim.api.nvim_create_autocmd("BufWritePre", {
"   pattern = { "*.go" },
"   callback = vim.lsp.buf.format,
" })
autocmd BufWritePre *.go lua vim.lsp.buf.code_action({ source = { organizeImports = true } })

set fileencodings=utf-8
set termguicolors
set background=light
colorscheme NeoSolarized
":set hidden means that the buffer of the old file will only be hidden when you switch to the new file. When you switch back, you still have your undo history.
set hidden

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
