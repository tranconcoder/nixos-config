return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = { theme = "auto" },
      tabline = {
        lualine_a = {
          {
            "buffers",
            show_filename_only = true,
            show_modified_status = true,
            mode = 2, -- 0: buffer name, 1: buffer index, 2: buffer name + index
            max_length = vim.o.columns,
            filetype_names = {
              TelescopePrompt = "Telescope",
              dashboard = "Dashboard",
              packer = "Packer",
              fzf = "FZF",
              alpha = "Alpha",
            },
            buffers_color = {
              active = "lualine_b_normal",
              inactive = "lualine_b_inactive",
            },
            symbols = {
              modified = " ●",
              alternate_file = "",
              directory = "",
            },
          },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          {
            "tabs",
            max_length = vim.o.columns,
            mode = 2,
            tabs_color = {
              active = "lualine_a_normal",
              inactive = "lualine_a_inactive",
            },
          },
        },
      },
    })
  end,
}
