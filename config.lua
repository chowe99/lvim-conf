-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--

lvim.builtin.nvimtree.active = false
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
lvim.plugins = {
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
  {
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function ()
      require('neo-tree').setup {
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
}

lvim.keys.normal_mode['<leader>sf'] = require('telescope.builtin').find_files
lvim.keys.normal_mode['<leader>sg'] = require('telescope.builtin').live_grep
lvim.keys.normal_mode['<leader>e'] = vim.diagnostic.open_float
lvim.keys.normal_mode['<leader>/'] = function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end
lvim.keys.normal_mode['<leader>rn'] = vim.lsp.buf.rename
