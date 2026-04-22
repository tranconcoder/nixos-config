-- lua/modules/plugins/git.lua
return {

	-- Gitsigns: blame popup, hunk preview, stage/reset
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPost",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			current_line_blame = false,
			current_line_blame_opts = {
				virt_text = true,
				delay = 300,
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "]h", gs.next_hunk, "Next hunk")
				map("n", "[h", gs.prev_hunk, "Prev hunk")
				map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
				map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>gb", gs.blame_line, "Blame line popup")
				map("n", "<leader>gd", gs.diffthis, "Diff this")
				map("n", "<leader>gB", function()
					gs.toggle_current_line_blame()
				end, "Toggle inline blame")
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk (visual)")
			end,
		},
	},

	-- Inline blame (hiện author cuối dòng)
	{
		"f-person/git-blame.nvim",
		event = "BufReadPost",
		opts = {
			enabled = true,
			-- Thêm 5 khoảng trắng ở đầu chuỗi để tạo khoảng cách với ký tự cuối cùng
			message_template = "     <author> • <date> • <summary>",
			date_format = "%d/%m/%Y",
			-- XÓA HOÀN TOÀN DÒNG: virtual_text_column = 80,
			highlight_group = "Comment",
		},
		keys = {
			{ "<leader>gT", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame (virtual text)" },
		},
	},

	-- LazyGit UI
	{
		"kdheepak/lazygit.nvim",
		cmd = "LazyGit",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
}
