return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup({ signs = { add = { text = "▎" }, delete = { text = "▎" } } })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    config = function()
      require("neogit").setup({ integrations = { telescope = true } })
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>")
    end,
  },
}