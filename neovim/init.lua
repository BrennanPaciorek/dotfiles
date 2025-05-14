require("plugins")

local plugins = {
	"nvim-treesitter/nvim-treesitter",
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/nvim-cmp",
	"hrsh7th/vim-vsnip",
	{
		'nvim-telescope/telescope.nvim', 
		tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
	},
}

local lazy_opts = {}

require("lazy").setup(plugins, lazy_opts)
require("mason").setup()

require("opts")
require("telescope-config")

require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "rust", "toml", "typescript" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true }, 
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- Configure rust_analyzer
vim.lsp.config('rust_analyzer', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['rust-analyzer'] = {},
  },
})

-- Configure tsserver
vim.lsp.config('tsserver', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['tsserver'] = {},
  },
})

-- Configure pyright
vim.lsp.config('pyright', {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    ['pyright'] = {},
  },
})

-- Configure jdtls
vim.lsp.config('jdtls', {
  -- Server-specific settings. See `:help lsp-quickstart`
  init_options = {
    extendedClientCapabilities = {
      classFileContentsSupport = true,
    },
  },
  settings = {
    ['jdtls'] = {},
  },
})

-- Enable LSP
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('tsserver')
vim.lsp.enable('pyright')
vim.lsp.enable('jdtls')

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- tex autocmd Setup
vim.api.nvim_create_autocmd('FileType', {
	desc = "auto compile latex to pdf on write",
	pattern = "tex",
	group = vim.api.nvim_create_augroup("latex_write", { clear = true }),
	callback = function (opts)
		local filename = vim.fn.expand("%")
		vim.api.nvim_create_autocmd('BufWritePost', {
			buffer = opts.buf,
			command = 'silent exec "!pdflatex '..filename..'"'
		})
	end,
})

