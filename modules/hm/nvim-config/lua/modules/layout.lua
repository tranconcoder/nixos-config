local M = {}

local note_file = vim.fn.expand("~/.local/share/nvim/notes.md")
local note_win = nil
local tree_win = nil

-- 3:5:2 ratio (tree:code:note)
function M.get_widths()
  local total = vim.o.columns
  local tree_w = math.floor(total * 3 / 10)
  local code_w = math.floor(total * 5 / 10)
  local note_w = total - tree_w - code_w
  return tree_w, code_w, note_w
end

function M.find_tree_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("NvimTree") then
      return win
    end
  end
  return nil
end

function M.find_note_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname == note_file then
      return win
    end
  end
  return nil
end

function M.find_code_win()
  local tree = M.find_tree_win()
  local note = M.find_note_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if win ~= tree and win ~= note then
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.bo[buf].buftype
      if buftype == "" then
        return win
      end
    end
  end
  return nil
end

function M.enforce_layout()
  local tree_w, code_w, note_w = M.get_widths()
  local tree = M.find_tree_win()
  local note = M.find_note_win()
  local code = M.find_code_win()
  
  if tree and vim.api.nvim_win_is_valid(tree) then
    vim.api.nvim_win_set_width(tree, tree_w)
  end
  if code and vim.api.nvim_win_is_valid(code) then
    vim.api.nvim_win_set_width(code, code_w)
  end
  if note and vim.api.nvim_win_is_valid(note) then
    vim.api.nvim_win_set_width(note, note_w)
  end
end

function M.setup()
  vim.defer_fn(function()
    vim.fn.mkdir(vim.fn.fnamemodify(note_file, ":h"), "p")
    if vim.fn.filereadable(note_file) == 0 then
      vim.fn.writefile({"# Tasks & Notes", "", "- [ ] "}, note_file)
    end
    
    local tree_w, code_w, note_w = M.get_widths()
    
    -- Open nvim-tree (creates left window)
    require("nvim-tree.api").tree.open()
    
    -- Wait for tree to open then setup
    vim.defer_fn(function()
      local tree = M.find_tree_win()
      if tree then
        vim.api.nvim_win_set_width(tree, tree_w)
        vim.api.nvim_set_current_win(tree)
        
        -- Split to create code window (middle)
        vim.cmd("rightbelow vsplit")
        local code = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(code, code_w)
        
        -- Split to create note window (right)
        vim.cmd("rightbelow vsplit " .. note_file)
        note_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_width(note_win, note_w)
        
        -- Set note properties
        local buf = vim.api.nvim_get_current_buf()
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].swapfile = false
        vim.bo[buf].filetype = "markdown"
        
        -- Focus code window
        vim.api.nvim_set_current_win(code)
        
        -- Enforce layout every 100ms to prevent random resizing
        M.layout_timer = vim.loop.new_timer()
        M.layout_timer:start(0, 100, vim.schedule_wrap(function()
          M.enforce_layout()
        end))
      end
    end, 200)
  end, 100)
end

-- Stop enforcing layout on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    if M.layout_timer then
      M.layout_timer:stop()
      M.layout_timer:close()
    end
  end,
})

-- Redirect files opened in note window to code window
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    vim.defer_fn(function()
      local bufname = vim.api.nvim_buf_get_name(args.buf)
      local buftype = vim.bo[args.buf].buftype
      
      if buftype ~= "" or bufname == "" or bufname == note_file or bufname:match("NvimTree") then
        return
      end
      
      local note = M.find_note_win()
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local win_buf = vim.api.nvim_win_get_buf(win)
        if win_buf == args.buf and win == note then
          local code = M.find_code_win()
          if code then
            vim.api.nvim_win_set_buf(code, args.buf)
            local note_bufnr = vim.fn.bufadd(note_file)
            vim.api.nvim_win_set_buf(note, note_bufnr)
            vim.bo[note_bufnr].filetype = "markdown"
            vim.api.nvim_set_current_win(code)
          end
          break
        end
      end
    end, 50)
  end,
})

-- Keep note window clean
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = note_file,
  callback = function()
    vim.bo.buftype = "nofile"
    vim.bo.swapfile = false
  end,
})

function M.toggle_tree()
  local api = require("nvim-tree.api")
  if api.tree.is_visible() then
    api.tree.close()
  else
    api.tree.open({ find_file = true })
    vim.defer_fn(function()
      local tree = M.find_tree_win()
      local tree_w = math.floor(vim.o.columns * 3 / 10)
      if tree then
        vim.api.nvim_win_set_width(tree, tree_w)
      end
    end, 100)
  end
end

function M.toggle_note()
  local note = M.find_note_win()
  if note and vim.api.nvim_win_is_valid(note) then
    vim.api.nvim_win_close(note, true)
    note_win = nil
  else
    local code = M.find_code_win()
    if code then
      vim.api.nvim_set_current_win(code)
      vim.cmd("rightbelow vsplit " .. note_file)
      note_win = vim.api.nvim_get_current_win()
      local note_w = math.floor(vim.o.columns * 2 / 10)
      vim.api.nvim_win_set_width(note_win, note_w)
      local buf = vim.api.nvim_get_current_buf()
      vim.bo[buf].buftype = "nofile"
      vim.bo[buf].swapfile = false
      vim.bo[buf].filetype = "markdown"
      vim.api.nvim_set_current_win(code)
    end
  end
end

-- Auto-save note
vim.api.nvim_create_autocmd({"BufLeave", "VimLeave", "TextChanged", "InsertLeave"}, {
  pattern = note_file,
  callback = function()
    if vim.bo.modified then
      vim.cmd("silent write")
    end
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = M.setup,
  once = true,
})

vim.keymap.set("n", "<A-e>", M.toggle_tree, { desc = "Toggle nvim-tree" })
vim.keymap.set("n", "<A-n>", M.toggle_note, { desc = "Toggle note panel" })

return M
