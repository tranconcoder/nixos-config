return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          telescope = { enabled = true },
          lualine = true,
          which_key = true,
          mason = true,
          dap = { enabled = true, ui = { enabled = true } },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}