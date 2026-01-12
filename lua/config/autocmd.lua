-- Автооткрытие только для директорий
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local is_dir = vim.fn.isdirectory(data.file) == 1
    if is_dir then
      vim.cmd("cd " .. vim.fn.fnameescape(data.file))
      vim.cmd("Neotree filesystem reveal left")
    end
  end,
})
