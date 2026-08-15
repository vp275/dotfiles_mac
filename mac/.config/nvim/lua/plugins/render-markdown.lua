return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    keys = {
      {
        "<leader>mp",
        function()
          require("mdcat-preview").open()
        end,
        desc = "Markdown preview (mdcat)",
      },
      {
        "<leader>mc",
        function()
          require("mdcat-preview").open_pandoc()
        end,
        desc = "Markdown preview (Pandoc grid)",
      },
      {
        "<leader>mg",
        function()
          require("mdcat-preview").open_glow()
        end,
        desc = "Markdown preview (Glow)",
      },
    },
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup({
          ensure_installed = { "markdown", "markdown_inline" },
          highlight = { enable = true },
        })
      end
    end,
  },
}
