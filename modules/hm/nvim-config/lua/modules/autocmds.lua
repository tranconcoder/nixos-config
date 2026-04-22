vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
  group = vim.api.nvim_create_augroup("auto-save", { clear = true }),
  callback = function(args)
    local buf = args.buf
    if
      vim.api.nvim_buf_is_valid(buf)
      and vim.bo[buf].modified
      and not vim.bo[buf].readonly
      and vim.api.nvim_buf_get_name(buf) ~= ""
      and vim.bo[buf].buftype == ""
    then
      vim.api.nvim_buf_call(buf, function()
        -- Save without triggering swap file updates
        vim.cmd("silent! noautocmd write")
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Handle swap file conflicts - auto-choose 'read from disk' when file hasn't been modified
vim.api.nvim_create_autocmd("SwapExists", {
  group = vim.api.nvim_create_augroup("swap-exists", { clear = true }),
  callback = function()
    vim.v.swapchoice = "e"  -- 'e' = edit anyway, 'r' = read from swap, 'd' = delete swap
  end,
})

-- Auto-refresh files edited by external applications
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = vim.api.nvim_create_augroup("auto-refresh-external", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(buf)
    
    -- Skip special buffers, empty buffers, and read-only files
    if bufname == "" or vim.bo[buf].buftype ~= "" or vim.bo[buf].readonly then
      return
    end
    
    -- Check if file exists and is readable
    if vim.fn.filereadable(bufname) == 1 then
      -- Check if file was modified externally
      local file_changed = vim.fn.getftime(bufname) > vim.fn.getbufvar(buf, "changedtick")
      
      if file_changed and not vim.bo[buf].modified then
        -- File was changed externally and we haven't modified it locally
        vim.cmd("checktime " .. buf)
      end
    end
  end,
})
