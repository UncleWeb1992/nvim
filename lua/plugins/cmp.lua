return {
	{
		-- nvim-cmp - плагин автодополнения (как IntelliSense в VSCode)
		-- Документация: https://github.com/hrsh7th/nvim-cmp
		"hrsh7th/nvim-cmp",

		-- Загружать при входе в режим вставки или командной строки
		event = { "InsertEnter", "CmdlineEnter" },

		-- Зависимости (другие плагины, которые нужны для работы)
		dependencies = {
			-- Источники для автодополнения:
			"hrsh7th/cmp-nvim-lsp", -- Дополнения от LSP серверов (основной)
			"hrsh7th/cmp-buffer", -- Дополнения из текста в буфере
			"hrsh7th/cmp-path", -- Дополнения путей к файлам
			"hrsh7th/cmp-cmdline", -- Дополнения для командной строки

			-- Движок сниппетов (фрагменты кода):
			"L3MON4D3/LuaSnip", -- Движок сниппетов (как расширяемые шаблоны)
			"saadparwaiz1/cmp_luasnip", -- Интеграция LuaSnip с cmp

			-- Красивые иконки для автодополнения:
			"onsails/lspkind.nvim", -- Иконки для LSP (хотя вы используете кастомные)

			-- Автоматическое закрытие скобок (интеграция):
			"windwp/nvim-autopairs", -- Закрывает скобки автоматически

			"hrsh7th/cmp-nvim-lua", -- Lua API Neovim
			"f3fora/cmp-spell", -- Проверка орфографии
			"hrsh7th/cmp-emoji", -- Эмодзи (у вас уже есть)
			"kdheepak/cmp-latex-symbols", -- LaTeX символы
			"octaltree/cmp-look", -- Словарь
		},

		config = function()
			local cmp = require("cmp") -- Основной модуль автодополнения
			local luasnip = require("luasnip") -- Модуль сниппетов

			-- Загрузить сниппеты из VSCode (удобно, если вы перешли с VSCode)
			-- Это загрузит сниппеты из установленных VSCode расширений
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Кастомные иконки для разных типов дополнений (Nerd Font символы)
			-- Важно: без пробелов в конце для чистого отображения
			local kind_icons = {
				Text = "", -- Текст
				Method = "", -- Метод
				Function = "", -- Функция
				Constructor = "", -- Конструктор
				Field = "", -- Поле класса
				Variable = "", -- Переменная
				Class = "", -- Класс
				Interface = "", -- Интерфейс
				Module = "", -- Модуль
				Property = "", -- Свойство
				Unit = "", -- Юнит-тест
				Value = "", -- Значение
				Enum = "", -- Перечисление
				Keyword = "", -- Ключевое слово
				Snippet = "", -- Сниппет
				Color = "", -- Цвет
				File = "", -- Файл
				Reference = "", -- Ссылка
				Folder = "", -- Папка
				EnumMember = "", -- Элемент перечисления
				Constant = "", -- Константа
				Struct = "", -- Структура
				Event = "", -- Событие
				Operator = "", -- Оператор
				TypeParameter = "", -- Параметр типа
				Copilot = "", -- GitHub Copilot
			}

			-- Основная настройка nvim-cmp
			cmp.setup({
				-- Настройка сниппетов
				snippet = {
					expand = function(args)
						-- Расширяет сниппет при выборе
						luasnip.lsp_expand(args.body)
					end,
				},

				-- Окно автодополнения
				window = {
					-- Основное окно с предложениями
					completion = {
						border = "single", -- Рамка вокруг окна
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						scrollbar = false, -- Без скроллбара (чище)
					},
					-- Окно документации (появляется при выделении элемента)
					documentation = {
						border = "single",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
						max_width = 80, -- Максимальная ширина
						max_height = 12, -- Максимальная высота
					},
				},

				-- Форматирование элементов в списке
				formatting = {
					-- Порядок полей в элементе
					fields = { "kind", "abbr", "menu" },

					-- Функция форматирования каждого элемента
					format = function(entry, vim_item)
						-- Добавляем иконку (без пробелов!)
						vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or "")

						-- Меню с указанием источника дополнения
						vim_item.menu = ({
							nvim_lsp = "  ", -- LSP сервер
							nvim_lua = "  ", -- Neovim Lua API
							luasnip = " 󰆐 ", -- Сниппеты
							buffer = " 󰾷 ", -- Текущий буфер
							path = " 󰉖 ", -- Пути к файлам
							emoji = " 󰱺 ", -- Эмодзи
							git = " 󰊢 ", -- Git
						})[entry.source.name] or ""

						-- Ограничиваем длину текста (чтобы не вылезало за границы)
						vim_item.abbr = string.sub(vim_item.abbr, 1, 50)

						return vim_item
					end,
				},

				-- Горячие клавиши (маппинги)
				mapping = {
					-- Прокрутка документации
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Прокрутить док вверх
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- Прокрутить док вниз

					-- Управление дополнениями
					["<C-Space>"] = cmp.mapping.complete(), -- Открыть список дополнений
					["<C-e>"] = cmp.mapping.abort(), -- Закрыть список

					-- Подтверждение выбора
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace, -- Заменять текущий текст
						select = true, -- Автовыбор если есть предложения
					}),

					-- Навигация по списку
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							-- Если список виден - выбрать следующий элемент
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							-- Если есть сниппет - развернуть его или перейти к следующей точке
							luasnip.expand_or_jump()
						else
							-- Иначе - обычное поведение Tab
							fallback()
						end
					end, { "i", "s" }), -- Работает в режимах Insert и Select

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							-- Выбрать предыдущий элемент
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							-- Перейти к предыдущей точке в сниппете
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				},

				-- Источники автодополнения (в порядке приоритета)
				sources = {
					{ name = "nvim_lsp", priority = 100 }, -- LSP сервер (самый важный)
					{ name = "luasnip", priority = 90 }, -- Сниппеты
					{ name = "buffer", priority = 70 }, -- Текст из буфера
					{ name = "path", priority = 60 }, -- Пути к файлам
					{ name = "emoji", priority = 40 }, -- Эмодзи :smile:
				},

				-- Экспементальные фичи
				experimental = {
					ghost_text = { -- Полупрозрачный текст предпросмотра
						hl_group = "Comment", -- Стиль как у комментариев
					},
				},
			})

			-- ============================================
			-- НАСТРОЙКИ ДЛЯ КОМАНДНОЙ СТРОКИ
			-- ============================================

			-- Автодополнение при поиске (/ или ?)
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(), -- Стандартные клавиши
				sources = {
					{ name = "buffer" }, -- Только из буфера
				},
			})

			-- Автодополнение в командной строке (:команды)
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" }, -- Сначала пути к файлам
				}, {
					{ name = "cmdline" }, -- Затем команды
				}),
			})

			-- ============================================
			-- КАСТОМНЫЕ ЦВЕТА ДЛЯ КРАСИВОГО ВИДА
			-- ============================================

			-- Меню (источник дополнения)
			vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#c586c0", italic = true })
			-- Основной текст
			vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#d4d4d4" })
			-- Совпадающая часть текста
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#569cd6", bold = true })
			-- Нечеткое совпадение
			vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#569cd6", bold = true })
		end,
	},
}
