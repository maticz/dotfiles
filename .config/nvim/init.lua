local vim = vim

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and (ev.data.kind == 'install' or ev.data.kind == 'update') then
      vim.cmd('TSUpdate')
    end
  end,
})

vim.pack.add({
  'https://github.com/maxmx03/solarized.nvim',
  'https://github.com/mbbill/undotree',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/tpope/vim-fugitive',
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
  -- 'https://github.com/github/copilot.vim',
  -- 'https://github.com/nvim-lua/plenary.nvim',
  -- 'https://github.com/olimorris/codecompanion.nvim',
})

-- require("codecompanion").setup({
--   strategies = {
--     chat = {
--       adapter = {
--         name = "copilot",
--         model = "claude-sonnet-4",
--       },
--     },
--   },
--   opts = {
--     log_level = "DEBUG",
--   },
-- })

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "enter",
    },

    appearance = {
        --use_nvim_cmp_as_default = true,
        -- nerd_font_variant = "normal",
        nerd_font_variant = "mono",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },

    sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } }
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    vim.keymap.set('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.keymap.set('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    vim.keymap.set("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

    if client and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          if vim.bo.filetype == "go" then
            local params = vim.lsp.util.make_range_params()
            params.context = { only = { "source.organizeImports" } }
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
            for _, res in pairs(result or {}) do
              for _, action in pairs(res.result or {}) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
                end
              end
            end
          end
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})

vim.lsp.enable({ "gopls" })--, "pyright" , "ccls" , "ts_ls", "lua_ls"})

require('nvim-treesitter').setup {}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go" },--, "python", "bash", "html", "javascript", "json", "make", "c", "lua", "rust" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.opt.fileencodings = "utf-8"
vim.opt.termguicolors = true
vim.opt.background = "dark"
require('solarized').setup({ variant = 'autumn' })
vim.cmd.colorscheme("solarized")
--:set hidden means that the buffer of the old file will only be hidden when you switch to the new file. When you switch back, you still have your undo history.
vim.opt.hidden = true
vim.opt.clipboard:append("unnamedplus")
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99

vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<F5>", ":UndotreeToggle<CR>")
vim.keymap.set("n", "<C-P>", ':lua require("fzf-lua").files()<CR>')
vim.keymap.set("n", "<F2>", ":buffers<CR>:buffer<Space>")

-- These are to cancel the default behavior of d, D, c, C
-- to put the text they delete in the default register.
-- Note that this means e.g. "ad won't copy the text into
-- register a anymore.  You have to explicitly yank it.
vim.keymap.set({"n", "v"}, "d", '"_d')
vim.keymap.set({"n", "v"}, "D", '"_D')
vim.keymap.set({"n", "v"}, "c", '"_c')
vim.keymap.set({"n", "v"}, "C", '"_C')
-- Map p to P to prevent copying when pasting over something.
vim.keymap.set("x", "p", "P")
