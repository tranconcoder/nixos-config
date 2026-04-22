return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = "Telescope",
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules", ".git", "dist", "build", "__pycache__" },
          path_display = { "smart" },
          mappings = {
            i = { ["<Esc>"] = require("telescope.actions").close },
          },
        },
        pickers = { find_files = { theme = "dropdown" }, live_grep = { theme = "ivy" } },
        extensions = { ["ui-select"] = { theme = "dropdown" } },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("ui-select")
    end,
  },
}