return {
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    opts = {
      window = {
        width = 80,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
        },
      },
      plugins = {
        twilight = { enabled = false },
      },
    },
  },
  {
    "folke/twilight.nvim",
    opts = {},
  },
}
