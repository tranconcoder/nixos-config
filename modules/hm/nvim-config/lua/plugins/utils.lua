return {
  { "folke/which-key.nvim", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = { "BufReadPost", "BufNewFile" }, config = true },
  { "windwp/nvim-autopairs", event = "InsertEnter", config = true },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" }, config = true },
  { "folke/trouble.nvim", cmd = "Trouble", config = true },
  { "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, config = true },
  { "nvimdev/dashboard-nvim", event = "VimEnter", config = true },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
}