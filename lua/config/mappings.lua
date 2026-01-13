vim.g.mapleader = " "

-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree focus<CR>")
vim.keymap.set("n", "<leader>o", ":Neotree focus git_status<CR>")

-- Рефакторинг
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true }) -- Сохранить
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { noremap = true, silent = true }) -- Сохранить в режиме вставки
vim.keymap.set("v", "<C-s>", "<Esc>:w<CR>gv", { noremap = true, silent = true }) -- Сохранить в визуальном режиме

-- Включим продвинутый undo
vim.opt.undofile = true -- Сохранять историю между сессиями
vim.opt.undolevels = 10000 -- Больше уровней отмены

-- Настройка отмены с учетом режимов
vim.keymap.set("i", "<C-z>", "<Esc>ui", { desc = "Undo (insert mode)" })
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("v", "<C-z>", "u", { desc = "Undo" })

vim.keymap.set("i", "<C-y>", "<Esc><C-r>i", { desc = "Redo (insert mode)" })
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })
vim.keymap.set("v", "<C-y>", "<C-r>", { desc = "Redo" })
