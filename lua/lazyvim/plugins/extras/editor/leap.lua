return {
  -- disable flash
  { "folke/flash.nvim", enabled = false, optional = true },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    enabled = true,
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "o" }, desc = "Leap backward to" },
      { "gw", mode = { "n", "x", "o" }, desc = "Leap from windows" },
      { "x", mode = { "n", "x", "o" }, desc = "Leap forward till" },
      { "X", mode = { "n", "x", "o" }, desc = "Leap backward till" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      -- leap.add_default_mappings(true)
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n", "o" }, "S", "<Plug>(leap-backward-to)") -- exclude 'x' for surround
      vim.keymap.set({ "n", "x", "o" }, "x", "<Plug>(leap-forward-till)")
      vim.keymap.set({ "n", "x", "o" }, "X", "<Plug>(leap-backward-till)")
      vim.keymap.set({ "n", "x", "o" }, "gw", "<Plug>(leap-from-window)") -- vim.keymap.del({ "n", "x", "o" }, "gs") -- do not enable this, it overwrites grepper
      -- vim.keymap.del({ "x", "o" }, "x")
      -- vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  -- rename surround mappings from gs to gz to prevent conflict with leap
  {
    "echasnovski/mini.surround",
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
