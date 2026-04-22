return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require("nvim-tree").setup({
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        view = { side = "right", width = 35, hide_root_folder = false },
        filters = { dotfiles = false },
        renderer = {
          group_empty = true,
          indent_width = 2,
          icons = { webdev_colors = true },
        },
        actions = { open_file = { window_picker = { enable = false } } },
      })
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>")
      vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<cr>")
    end,
  },
}