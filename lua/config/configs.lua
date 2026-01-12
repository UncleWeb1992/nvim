-- Поиск
vim.opt.ignorecase = true -- Игнорирует регистр при поиске
vim.opt.smartcase = true -- Если есть заглавные буквы, поиск становится чувствительным к регистру

-- Мышь
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Нумерация строк
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.spelllang = { "ru", "en" }
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.wrap = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
