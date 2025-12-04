call plug#begin()
Plug 'iCyMind/NeoSolarized'
Plug 'mbbill/undotree'
Plug 'tomtom/tcomment_vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-fugitive'
"Plug 'puremourning/vimspector'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
", {'branch': '0.5-compat', 'do': ':TSUpdate'}
"Plug 'echasnovski/mini.diff'
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'olimorris/codecompanion.nvim'
call plug#end()

let g:vimspector_enable_mappings = 'HUMAN'

set completeopt=menuone,noselect

lua << EOF
  require("codecompanion").setup({
    strategies = {
      chat = {
        adapter = {
          name = "copilot",
          model = "claude-sonnet-4",
        },
      },
    },
    opts = {
      log_level = "DEBUG",
    },
  })
EOF

lua << EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

        -- For `mini.snippets` users:
        -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
        -- insert({ body = args.body }) -- Insert at cursor
        -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
        -- require("cmp.config").set_onetime({ sources = {} })
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]]-- 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  ---- Set up lspconfig.
  --local capabilities = require('cmp_nvim_lsp').default_capabilities()
  ---- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
  --  capabilities = capabilities
  --}

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
local servers = { "gopls", "pyright" , "ccls" , "ts_ls"}
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
set background=dark
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
