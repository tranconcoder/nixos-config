local M = {}

local note_file = vim.fn.expand("~/.local/share/nvim/notes.md")
local note_win = nil
local tree_visible = true

-- Calculate widths: side panels fixed 30%, code takes remaining
function M.get_widths()
  local total = vim.o.columns
  local tree_w = math.floor(total * 0.3)
  local note_w = math.floor(total * 0.3)
  local code_w = total
  
  if tree_visible then
    code_w = code_w - tree_w
  else
    tree_w = 0
  end
  
  if note_win and vim.api.nvim_win_is_valid(note_win) then
    code_w = code_w - note_w
  else
    note_w = 0
  end
  
  return tree_w, code_w, note_w
end

-- Resize code buffer to fill available space
function M.resize_code()
  local _, code_w, _ = M.get_widths()
  
  -- Find code buffer window (should be middle or left if tree hidden)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.bo[buf].buftype
    local bufname = vim.api.nvim_buf_get_name(buf)
    
    -- Code buffer is not nvim-tree, not note, not special
    if buftype == "" and not bufname:match("NvimTree") and bufname ~= note_file then
      vim.api.nvim_win_set_width(win, code_w)
      break
    end
  end
end

-- Setup initial layout
function M.setup()
  vim.defer_fn(function()
    -- Ensure note directory exists
    vim.fn.mkdir(vim.fn.fnamemodify(note_file, ":h"), "p")
    
    -- Create note file if not exists
    if vim.fn.filereadable(note_file) == 0 then
      vim.fn.writefile({"# Tasks & Notes", "", "- [ ] "}, note_file)
    end
    
    local total = vim.o.columns
    local tree_w = math.floor(total * 0.3)
    local note_w = math.floor(total * 0.3)
    
    -- Open nvim-tree on left
    require("nvim-tree.api").tree.open()
    
    -- Resize tree to 30%
    vim.cmd("wincmd h")
    vim.cmd("vertical resize " .. tree_w)
    
    -- Go to code buffer (middle) and create note panel on right
    vim.cmd("wincmd l")
    vim.cmd("vsplit " .. note_file)
    note_win = vim.api.nvim_get_current_win()
    
    -- Move note to far right and resize
    vim.cmd("wincmd L")
    vim.cmd("vertical resize " .. note_w)
    
    -- Set note buffer properties
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = ""
    vim.bo[buf].swapfile = true
    vim.bo[buf].filetype = "markdown"
    
    -- Go back to code buffer (middle) and resize
    vim.cmd("wincmd h")
    M.resize_code()
  end, 300)
end

-- Toggle nvim-tree with Alt+E
function M.toggle_tree()
  local api = require("nvim-tree.api")
  local total = vim.o.columns
  if tree_visible then
    api.tree.close()
    tree_visible = false
  else
    tree_visible = true
    api.tree.open({ find_file = true })
    vim.cmd("wincmd h")
    vim.cmd("vertical resize " .. math.floor(total * 0.3))
    vim.cmd("wincmd l")
  end
  M.resize_code()
end

-- Toggle note panel with Alt+N
function M.toggle_note()
  local total = vim.o.columns
  if note_win and vim.api.nvim_win_is_valid(note_win) then
    vim.api.nvim_win_close(note_win, true)
    note_win = nil
  else
    -- Open note on the far right
    vim.cmd("botright vsplit " .. note_file)
    note_win = vim.api.nvim_get_current_win()
    
    vim.cmd("vertical resize " .. math.floor(total * 0.3))
    
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = ""
    vim.bo[buf].swapfile = true
    vim.bo[buf].filetype = "markdown"
    
    -- Go back to code buffer
    vim.cmd("wincmd h")
  end
  M.resize_code()
end

-- Auto-save note buffer
vim.api.nvim_create_autocmd({"BufLeave", "VimLeave"}, {
  pattern = note_file,
  command = "write",
})

-- Setup layout on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = M.setup,
  once = true,
})

-- Keymaps
vim.keymap.set("n", "<A-e>", M.toggle_tree, { desc = "Toggle nvim-tree" })
vim.keymap.set("n", "<A-n>", M.toggle_note, { desc = "Toggle note panel" })

return M
