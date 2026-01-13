return {
	-- ================================================
	-- ПЛАГИН: nvim-neo-tree/neo-tree.nvim
	-- Современный файловый менеджер и навигатор для Neovim
	-- ================================================
	{
		"nvim-neo-tree/neo-tree.nvim", -- Основной плагин файлового менеджера
		branch = "v3.x", -- Используем стабильную ветку v3
		dependencies = { -- Зависимости, необходимые для работы
			"nvim-lua/plenary.nvim", -- Библиотека Lua функций
			"nvim-tree/nvim-web-devicons", -- Иконки для файлов и папок
			"MunifTanjim/nui.nvim", -- UI компоненты для Neovim
		},
		lazy = false, -- ⭐ ВАЖНО: загружать сразу при старте (не лениво)
		-- Это нужно для автооткрытия при запуске Neovim

		-- ================================================
		-- ИНИЦИАЛИЗАЦИЯ: АВТООТКРЫТИЕ ПРИ СТАРТЕ NEOVIM
		-- ================================================
		init = function()
			-- Создаем автокоманду, которая сработает при запуске Vim/Neovim
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					-- Ждем 50мс чтобы все плагины успели загрузиться
					vim.defer_fn(function()
						-- Определяем, нужно ли открывать дерево файлов
						local should_open_tree = false

						-- Проверка 1: если запустили просто `nvim` без аргументов
						if vim.fn.argc() == 0 then
							-- Запустили просто `nvim` - открываем дерево
							should_open_tree = true

						-- Проверка 2: если запустили с одним аргументом
						elseif vim.fn.argc() == 1 then
							-- Проверяем, является ли аргумент директорией
							local stat = vim.loop.fs_stat(vim.fn.argv(0))
							if stat and stat.type == "directory" then
								-- Запустили `nvim .` или `nvim папка` - открываем дерево
								should_open_tree = true
							end
						end

						-- Если нужно открыть дерево файлов
						if should_open_tree then
							-- Очистка: закрываем пустой начальный буфер если он есть
							-- Это нужно для чистого интерфейса при запуске
							local bufs = vim.api.nvim_list_bufs()
							for _, buf in ipairs(bufs) do
								-- Ищем пустые буферы (без имени и с 1 строкой)
								if vim.api.nvim_buf_get_name(buf) == "" and vim.api.nvim_buf_line_count(buf) <= 1 then
									vim.api.nvim_buf_delete(buf, { force = true })
								end
							end

							-- Открываем neo-tree слева с раскрытием текущей директории
							vim.cmd("Neotree filesystem reveal left")
						end
					end, 50) -- Задержка 50 миллисекунд
				end,
			})
		end,

		-- ================================================
		-- ОСНОВНАЯ КОНФИГУРАЦИЯ NEO-TREE
		-- ================================================
		config = function()
			require("neo-tree").setup({
				-- ⭐ ЗАКРЫТЬ NEOVIM ЕСЛИ NEO-TREE ПОСЛЕДНЕЕ ОКНО
				-- Если закрыть все файлы и останется только neo-tree - Neovim закроется
				close_if_last_window = true,

				-- Стиль границы всплывающих окон
				popup_border_style = "NC",

				-- Включить интеграцию с Git
				-- Показывает статус файлов (измененные, новые, удаленные)
				enable_git_status = true,

				-- Включить отображение диагностики LSP
				-- Показывает ошибки и предупреждения рядом с файлами
				enable_diagnostics = true,

				-- ============================================
				-- НАСТРОЙКИ ОКНА NEO-TREE
				-- ============================================
				window = {
					position = "left", -- Расположение: слева (можно "right", "float")
					width = 35, -- Ширина окна в символах

					-- Настройки горячих клавиш для окна neo-tree
					mappings = {
						["<space>"] = "none", -- ⭐ Отключаем пробел, чтобы не конфликтовал с лидером
						["q"] = "close_window", -- Закрыть окно neo-tree
						["<Esc>"] = "close_window", -- Esc также закрывает окно
					},
				},

				-- ============================================
				-- НАСТРОЙКИ ОТСТУПОВ И ИЕРАРХИИ
				-- ============================================
				indent = {
					indent_size = 2, -- Размер отступа (в пробелах)
					padding = 1, -- Дополнительный padding
					with_markers = true, -- Показывать маркеры отступов
					indent_marker = "│", -- Маркер для промежуточных уровней
					last_indent_marker = "└", -- Маркер для последнего элемента
					highlight = "NeoTreeIndentMarker", -- Группа подсветки для маркеров
					with_expanders = nil, -- Использовать expanders (раскрывающиеся стрелки)
					expander_collapsed = "", -- Иконка свернутой папки
					expander_expanded = "", -- Иконка раскрытой папки
					expander_highlight = "NeoTreeExpander", -- Подсветка expanders
				},

				-- ============================================
				-- НАСТРОЙКИ ФАЙЛОВОЙ СИСТЕМЫ
				-- ============================================
				filesystem = {
					-- ⭐ ЗАМЕНЯЕТ NETRW ПО УМОЛЧАНИЮ
					-- При открытии директории вместо стандартного netrw будет открываться neo-tree
					hijack_netrw_behavior = "open_default",

					-- Настройки фильтрации файлов
					filtered_items = {
						visible = true, -- Показывать фильтрованные элементы серым
						hide_dotfiles = false, -- Не скрывать скрытые файлы (начинающиеся с .)
						hide_gitignored = false, -- Не скрывать файлы из .gitignore
					},

					-- Автоматически следовать за текущим файлом
					-- При переключении между файлами neo-tree будет автоматически показывать текущий файл
					follow_current_file = {
						enabled = true,
					},

					-- Дополнительные настройки окна файловой системы
					window = {
						mappings = {
							["h"] = "close_node", -- Свернуть папку/узел
							["l"] = "open", -- Раскрыть папку/открыть файл
							["o"] = "open", -- Альтернативная клавиша для открытия
							["<CR>"] = "open", -- Enter для открытия файла/папки
						},
					},
				},
			})

			-- ================================================
			-- ГОРЯЧИЕ КЛАВИШИ ДЛЯ УПРАВЛЕНИЯ NEO-TREE
			-- ================================================

			-- Основная горячая клавиша для открытия/закрытия дерева файлов
			vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", {
				desc = "Toggle NeoTree", -- Описание для системы помощи
			})

			-- Дополнительные полезные горячие клавиши (можно добавить):
			-- vim.keymap.set("n", "<leader>ff", "<cmd>Neotree focus<cr>", { desc = "Focus NeoTree" })
			-- vim.keymap.set("n", "<leader>fr", "<cmd>Neotree reveal<cr>", { desc = "Reveal current file" })
		end,
	},
}
