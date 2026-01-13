return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- Установить тему как активную
			vim.cmd.colorscheme("tokyonight")

			require("tokyonight").setup({
				-- Стиль темы: "storm", "moon", "night", "day"
				style = "night", -- основной тёмный стиль

				-- Светлые темы (для дневного использования)
				-- style = "day"   -- светлая тема
				-- style = "moon"  -- тёмная, но более мягкая

				-- Прозрачный фон (для терминалов с прозрачностью)
				transparent = false, -- true для прозрачного фона

				-- Непрозрачные разделители (лайн, таблайн и т.д.)
				terminal_colors = true, -- интегрировать цвета в терминал

				-- Настройки цветов
				styles = {
					comments = { italic = true }, -- курсив в комментариях
					keywords = { italic = false }, -- ключевые слова без курсива
					functions = { bold = true }, -- функции жирным
					variables = {},
					sidebars = "dark", -- стиль для боковых панелей (NvimTree и т.д.)
					floats = "dark", -- стиль для плавающих окон
				},

				-- Цвет боковой панели (NvimTree, Telescope и др.)
				sidebars = {
					"qf", -- quickfix
					"vista_kind",
					"terminal",
					"packer",
					"spectre_panel",
					"NeogitStatus",
					"help",
				},

				-- Цвет панели дня (внизу)
				day_brightness = 0.3, -- яркость светлой темы

				-- Скрыть всплывающее меню
				hide_inactive_statusline = false,

				-- Тёмные разделители
				dim_inactive = false, -- затемнять неактивные окна

				-- Стиль курсора
				lualine_bold = false, -- жирный lualine

				-- Переопределение цветов
				on_colors = function(colors)
					-- Можно изменить любой цвет
					-- colors.bg = "#000000" -- чёрный фон
					-- colors.fg = "#ffffff" -- белый текст
				end,

				-- Переопределение highlight групп
				on_highlights = function(hl, colors)
					-- Пример: изменить цвет поиска
					hl.Search = { bg = colors.orange, fg = colors.bg }

					-- Цвет скроллбара (если используете nvim-scrollbar)
					hl.ScrollbarHandle = { bg = colors.comment }
					hl.ScrollbarError = { bg = colors.error }
					hl.ScrollbarWarn = { bg = colors.warning }
					hl.ScrollbarInfo = { bg = colors.info }
					hl.ScrollbarHint = { bg = colors.hint }

					-- Цвета для Telescope
					hl.TelescopeBorder = { fg = colors.border_highlight, bg = colors.bg }
					hl.TelescopePromptBorder = { fg = colors.border, bg = colors.bg_float }

					-- Цвета для NvimTree
					hl.NvimTreeNormal = { bg = colors.bg_dark }
				end,
			})

			-- Применить тему
			vim.cmd.colorscheme("tokyonight")

			-- Для корректной работы прозрачности
			if vim.g.transparency then
				vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
			end
		end,
	},
}
