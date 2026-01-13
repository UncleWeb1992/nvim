return {
	-- lualine.nvim - статусная строка (statusline) для Neovim
	-- GitHub: https://github.com/nvim-lualine/lualine.nvim
	-- Аналог: Powerline, airline, но современнее и на Lua
	"nvim-lualine/lualine.nvim",

	-- Функция настройки плагина
	config = function()
		require("lualine").setup({
			-- ============================================
			-- ОСНОВНЫЕ НАСТРОЙКИ
			-- ============================================
			options = {
				-- Цветовая схема статусной строки
				-- "auto" - автоматически подбирает тему из colorscheme
				-- Можно указать конкретную: "tokyonight", "onedark", "dracula", "material"
				-- "melange" - была у вас закомментирована
				theme = "auto",

				-- Показывать ли иконки (нужен nvim-web-devicons)
				icons_enabled = true,

				-- Разделители между секциями
				-- Левая часть:  (закругленный правый угол)
				-- Правая часть:  (закругленный левый угол)
				-- Для Nerd Font: символы Powerline
				section_separators = { left = "", right = "" },

				-- Разделители внутри секций
				-- "|" - вертикальная черта
				-- Можно использовать: "│", "", "", или "" для отключения
				component_separators = "|",

				-- ============================================
				-- ДОПОЛНИТЕЛЬНЫЕ ОПЦИИ (можно добавить):
				-- ============================================
				-- disabled_filetypes = {  -- Отключить для определенных файлов
				--   statusline = {},      -- в статусной строке
				--   winbar = {},          -- в верхней строке
				-- },
				--
				-- ignore_focus = {},      -- Игнорировать фокус для определенных окон
				--
				-- always_divide_middle = true,  -- Всегда делить среднюю секцию
				--
				-- globalstatus = false,   -- false = статусная строка в каждом окне
				--                        -- true = одна строка на весь Neovim (Neovim 0.7+)
				--
				-- refresh = {            -- Когда обновлять статусную строку
				--   statusline = 1000,   -- Каждые 1000мс
				--   tabline = 1000,      -- Для таблайна
				--   winbar = 1000,       -- Для верхней строки
				-- }
			},

			-- ============================================
			-- НАСТРОЙКА СЕКЦИЙ (можно кастомизировать):
			-- ============================================
			-- sections = {
			--   lualine_a = {'mode'},                    -- Слева: режим (NORMAL, INSERT, VISUAL)
			--   lualine_b = {'branch', 'diff', 'diagnostics'}, -- Ветка Git, изменения, ошибки
			--   lualine_c = {'filename'},                -- Имя файла
			--   lualine_x = {'encoding', 'fileformat', 'filetype'}, -- Кодировка, формат, тип
			--   lualine_y = {'progress'},                -- Прогресс в файле (10%)
			--   lualine_z = {'location'}                 -- Позиция курсора (строка:колонка)
			-- },
			--
			-- inactive_sections = {    -- Для неактивных окон
			--   lualine_a = {},
			--   lualine_b = {},
			--   lualine_c = {'filename'},
			--   lualine_x = {'location'},
			--   lualine_y = {},
			--   lualine_z = {}
			-- },
			--
			-- tabline = {},           -- Строка с табами (вверху)
			-- winbar = {},            -- Верхняя строка окна (хлебные крошки)
			-- extensions = {'nvim-tree', 'fugitive'} -- Расширения для других плагинов
		})
	end,

	-- Зависимости: нужны иконки для файлов
	dependencies = {
		-- nvim-web-devicons - иконки для разных типов файлов
		-- Устанавливает красивые иконки рядом с именами файлов
		"nvim-tree/nvim-web-devicons",
	},
}
