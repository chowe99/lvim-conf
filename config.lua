-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- General Vim Settings
vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""

-- Add asterisks in block comments
vim.opt.formatoptions:append({ "r" })

-- Disable default NvimTree
lvim.builtin.nvimtree.active = false

-- Language Servers
lvim.lsp.installer.setup.ensure_installed = {
  "lua_ls",
  "tsserver",    -- JavaScript/TypeScript
  "pyright",     -- Python
  "tailwindcss", -- Tailwind CSS
  "html",        -- HTML
  -- Add other servers if needed
}

local lsp_manager = require("lvim.lsp.manager")

-- Configure Tailwind CSS LSP with proper on_attach
lsp_manager.setup("tailwindcss", {
  on_attach = function(client, bufnr)
    -- Call the common on_attach function
    require("lvim.lsp").common_on_attach(client, bufnr)
    -- Removed tailwind-highlight setup
  end,
})

-- Configure HTML LSP
lsp_manager.setup("html", {
  on_attach = function(client, bufnr)
    -- Call the common on_attach function
    require("lvim.lsp").common_on_attach(client, bufnr)

    -- Optional: Add any HTML-specific configurations here
  end,
})

-- Set up the Lua language server
lsp_manager.setup("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        version = "LuaJIT",
        -- Setup your Lua path
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` and `lvim` globals
        globals = { "vim", "lvim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- Adjust these two settings if you encounter performance issues with large projects
        maxPreload = 1000,
        preloadFileSize = 1000,
      },
      telemetry = {
        enable = false, -- Do not send telemetry data containing a unique identifier
      },
    },
  },
})

local lspconfig = require('lspconfig')

-- Configure tsserver with formatting disabled
lspconfig.tsserver.setup {
  on_attach = function(client, bufnr)
    -- Disable tsserver formatting if you use prettier
    client.server_capabilities.documentFormattingProvider = false
    require('lvim.lsp').common_on_attach(client, bufnr)
  end,
  settings = {
    typescript = {
      jsx = true,
    },
    javascript = {
      jsx = true,
    },
  },
}
-- Configure pyright for Python
lspconfig.pyright.setup {
  on_attach = require('lvim.lsp').common_on_attach,
}

-- Plugins Configuration
lvim.plugins = {
  -- {
  --   "tpope/vim-fugitive",
  --   cmd = { "Git", "G" },
  --   config = function()
  --     -- Optional: Custom keybindings
  --     lvim.builtin.which_key.mappings["g"] = {
  --       name = "Git",
  --       s = { "<cmd>Git<CR>", "Status" },
  --       c = { "<cmd>Git commit<CR>", "Commit" },
  --       p = { "<cmd>Git push<CR>", "Push" },
  --       l = { "<cmd>Git log<CR>", "Log" },
  --       d = { "<cmd>Gdiffsplit<CR>", "Diff" },
  --     }
  --   end,
  -- },
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "BufRead",
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require('toggleterm').setup {
        size = 20,
        open_mapping = [[<c-\>]],
        shading_factor = 2,
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require('nvim-ts-autotag').setup {}
    end,
  },

  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function()
      local opts = {}
      opts.routes = {}

      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })

      local focused = true
      vim.api.nvim_create_autocmd("FocusGained", {
        callback = function()
          focused = true
        end,
      })
      vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
          focused = false
        end,
      })

      table.insert(opts.routes, 1, {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      })

      opts.commands = {
        all = {
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      opts.presets = {
        lsp_doc_border = true,
      }

      return opts
    end,
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 5000,
      background_colour = "#000000",
      render = "wrapped-compact",
    },
  },
  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<Tab>",   "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
      { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
    },
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },
  -- Highlight colors
  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {},
  },

  -- null-ls for lsps
  { "jose-elias-alvarez/null-ls.nvim" },

  -- React and JavaScript snippets
  {
    "dsznajder/vscode-es7-javascript-react-snippets",
    build = "yarn install --frozen-lockfile && yarn compile",
  },

  -- Tailwind CSS highlighting
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    lazy = true,
    event = "LspAttach",
    config = function()
      require("tailwindcss-colorizer-cmp").setup()
    end,
  },
  -- Neo-tree configuration
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('neo-tree').setup {
        close_if_last_window = true,
        window = {
          position = "right",
          width = 25,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
        },
      }
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      -- table: default groups
      groups = {
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
        "FloatBorder",
      },
      -- table: additional groups that should be cleared
      extra_groups = {
        "NormalFloat",
        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeNormalFloat",
        "NeoTreeEndOfBuffer",
      },
      -- table: groups you don't want to clear
      exclude_groups = {},
    }
  },
}

-- Formatter setup
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  -- For JavaScript/TypeScript
  {
    command = "prettierd",
    filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "vue", "html", "css", "json", "yaml" },
  },
  -- For Python
  {
    command = "black",
    filetypes = { "python" },
  },
}

-- Linter setup
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  -- For JavaScript/TypeScript
  {
    command = "eslint_d",
    filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact", "vue" },
  },
  -- For Python
  {
    command = "flake8",
    filetypes = { "python" },
  },
}

-- ======================================
-- Treesitter Configuration
-- ======================================
lvim.builtin.treesitter.ensure_installed = {
  "javascript",
  "typescript",
  "tsx", -- For React JSX
  "python",
  "html",
  "css",
  "json",
  "yaml",
  "gitignore",
  "graphql",
  "http",
  "scss",
  "sql",
  "vim",
  "lua",
}

lvim.builtin.treesitter.highlight.enable = true

-- Additional Treesitter configurations
require('nvim-treesitter.configs').setup {
  ensure_installed = lvim.builtin.treesitter.ensure_installed,
  highlight = {
    enable = lvim.builtin.treesitter.highlight.enable,
  },
  autotag = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
  },
}

-- Enable format on save
lvim.format_on_save = true

-- DAP setup
local dap = require('dap')

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
  },
}

-- Keybindings
lvim.keys.normal_mode['<leader>sf'] = require('telescope.builtin').find_files
lvim.keys.normal_mode['<leader>sg'] = require('telescope.builtin').live_grep
lvim.keys.normal_mode['<C-t>'] = ":Neotree toggle<CR>"
lvim.keys.normal_mode["x"] = '"_x'
lvim.keys.visual_mode["d"] = '"_d'

lvim.builtin.which_key.mappings['e'] = {}
lvim.keys.normal_mode['<leader>e'] = vim.diagnostic.open_float

-- Map ToggleTerm commands to open specific terminals
lvim.builtin.which_key.mappings['t'] = { -- Removed <leader> since which_key already uses <leader>
  group = "terminals",
  name = "Terminals",
  desc = "Terminal commands",
  ['1'] = { "<cmd>ToggleTerm 1<CR>", "Terminal 1" },
  ['2'] = { "<cmd>ToggleTerm 2<CR>", "Terminal 2" },
  ['3'] = { "<cmd>ToggleTerm 3<CR>", "Terminal 3" },
}

-- Mappings for vim-visual-multi
vim.g.VM_default_mappings = 0
vim.g.VM_maps = {
  ["Select All"] = '<leader><C-a>',   -- Space + Ctrl + a
  ["Find Under"] = '<C-n>',           -- Ctrl + n
  ["Add Cursor Down"] = '<C-M-Down>', -- Ctrl + alt + Down Arrow
  ["Add Cursor Up"] = '<C-M-Up>',     -- Ctrl + alt + Up Arrow
}

-- implement quickfix
local opts = { noremap = true, silent = true }
local function quickfix()
  vim.lsp.buf.code_action({
    filter = function(a) return a.isPreferred end,
    apply = true
  })
end
vim.keymap.set('n', '<leader>lq', quickfix, opts)

lvim.keys.normal_mode['<leader>rn'] = vim.lsp.buf.rename
