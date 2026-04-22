return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		priority = 100,
		config = function()
			-- Disable netrw (must be before setup)
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			require("nvim-tree").setup({
				-- Show hidden files (.env, .gitignore, etc.)
				filters = {
					dotfiles = false,
					custom = {},
				},

				view = {
					width = function()
						return math.floor(vim.o.columns * 0.3)
					end,
					side = "left",
					number = false,
					relativenumber = false,
					float = {
						enable = false,
					},
				},

				renderer = {
					highlight_opened_files = "all",
					indent_markers = {
						enable = true,
					},
					icons = {
						show = {
							file = true,
							folder = true,
							folder_arrow = true,
							git = true,
							modified = true,
						},
					},
				},

				git = {
					enable = true,
					ignore = false,
				},

				actions = {
					open_file = {
						resize_window = false,
						quit_on_open = false,
						window_picker = {
							enable = false,
						},
					},
				},

				update_focused_file = {
					enable = true,
					update_cwd = false,
					ignore_list = {},
				},
				sync_root_with_cwd = false,
				respect_buf_cwd = false,
				hijack_cursor = false,
				auto_close = false,
		})

		-- Toggle is handled by layout.lua (Alt+E)
		-- No direct keymap here to avoid conflicts

		end,
	},
}
