return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = " ", right = " " },
          section_separators = { left = " ", right = " " },
          disabled_filetypes = { statusline = { "dashboard", "alpha" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { "diagnostics" },
          lualine_x = { "filetype", "encoding", "fileformat" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        tabline = {},
        extensions = { "telescope", "nvim-tree" },
      })
    end,
  },
}