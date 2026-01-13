return {
	{
		"folke/neodev.nvim",
		ft = "lua", -- Загружать только для Lua файлов
		config = function()
			require("neodev").setup({
				-- Автодополнение для Neovim API
				library = {
					plugins = { "nvim-dap-ui" },
					types = true,
				},
			})
		end,
	},

	-- ==================================================
	-- ПЛАГИН: williamboman/mason.nvim
	-- Менеджер LSP серверов, форматтеров и линтеров
	-- ==================================================
	{
		"williamboman/mason.nvim",
		config = true, -- Автоматическая базовая настройка
	},

	-- ==================================================
	-- ПЛАГИН: williamboman/mason-lspconfig.nvim
	-- Мост между Mason и nvim-lspconfig
	-- ==================================================
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"gopls", -- Go Language Server
					"lua_ls", -- Lua Language Server
					"ts_ls", -- TypeScript Language Server
				},
			})
		end,
	},

	-- ==================================================
	-- ПЛАГИН: neovim/nvim-lspconfig
	-- Основная конфигурация Language Server Protocol
	-- ==================================================
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Для интеграции LSP с автодополнением
		},
		config = function()
			-- ============================================
			-- НАСТРОЙКА ЗНАЧКОВ ДИАГНОСТИКИ (ICONS)
			-- ============================================
			local signs = {
				Error = " ", -- Значок для ошибок (красный крестик)
				Warn = " ", -- Значок для предупреждений (желтый треугольник)
				Hint = " ", -- Значок для подсказок (лампочка)
				Info = " ", -- Значок для информации (синяя i)
			}

			-- Регистрируем значки для отображения на полях (gutter)
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, {
					text = icon, -- Символ для отображения
					texthl = hl, -- Highlight группа для цвета
					numhl = hl, -- Highlight для номеров строк
				})
			end

			-- ============================================
			-- CAPABILITIES: ВОЗМОЖНОСТИ ДЛЯ АВТОДОПОЛНЕНИЯ
			-- ============================================
			-- Базовые возможности LSP протокола
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- Расширяем возможности для работы с nvim-cmp (автодополнение)
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

			-- ============================================
			-- НАСТРОЙКА ОТОБРАЖЕНИЯ ДИАГНОСТИКИ (ОШИБОК)
			-- ============================================
			vim.diagnostic.config({
				-- virtual_text: текст ошибок рядом с кодом
				virtual_text = {
					prefix = "●", -- Префикс перед текстом ошибки
					spacing = 4, -- Отступ от кода
					-- Функция форматирования текста ошибки
					format = function(diagnostic)
						local icons = {
							Error = " ", -- Иконка для ошибок
							Warn = " ", -- Иконка для предупреждений
							Info = " ", -- Иконка для информации
							Hint = "󰌵 ", -- Иконка для подсказок
						}
						local icon = icons[diagnostic.severity] or " "
						return icon .. diagnostic.message -- Иконка + текст ошибки
					end,
				},
				signs = true, -- Показывать значки на полях
				underline = true, -- Подчеркивать проблемный код
				update_in_insert = false, -- Не обновлять в режиме вставки
				severity_sort = true, -- Сортировать ошибки по важности

				-- Настройки плавающих окон с ошибками
				float = {
					border = "rounded", -- Скругленная рамка
					max_width = 80, -- Максимальная ширина окна
					max_height = 20, -- Максимальная высота окна
					focusable = false, -- Окно не может получать фокус
					style = "minimal", -- Минималистичный стиль
					source = "always", -- Всегда показывать источник ошибки
					header = "", -- Без заголовка
					-- Функция префикса для плавающих окон
					prefix = function(diagnostic)
						local icons = {
							Error = " ",
							Warn = " ",
							Info = " ",
							Hint = "󰌵 ",
						}
						return icons[diagnostic.severity] or " "
					end,
				},
			})

			-- ============================================
			-- НАСТРОЙКА ЦВЕТОВ ДЛЯ КРАСИВОГО ОТОБРАЖЕНИЯ
			-- ============================================
			-- Цвет рамки плавающих окон
			vim.api.nvim_set_hl(0, "FloatBorder", {
				fg = "#7aa2f7", -- Синий цвет (Tokyo Night)
				bg = "none", -- Прозрачный фон
			})

			-- Цвет фона плавающих окон
			vim.api.nvim_set_hl(0, "NormalFloat", {
				bg = "#1a1b26", -- Темный фон (Tokyo Night)
			})

			-- Цвета для разных типов диагностики
			vim.api.nvim_set_hl(0, "DiagnosticError", {
				fg = "#f7768e", -- Красный для ошибок
				bold = true, -- Жирный шрифт
			})

			vim.api.nvim_set_hl(0, "DiagnosticWarn", {
				fg = "#e0af68", -- Желтый для предупреждений
			})

			vim.api.nvim_set_hl(0, "DiagnosticInfo", {
				fg = "#7aa2f7", -- Синий для информации
			})

			vim.api.nvim_set_hl(0, "DiagnosticHint", {
				fg = "#73daca", -- Бирюзовый для подсказок
			})

			-- ============================================
			-- ОБЩАЯ ФУНКЦИЯ ДЛЯ ВСЕХ LSP СЕРВЕРОВ (ON_ATTACH)
			-- ============================================
			-- Эта функция выполняется при подключении любого LSP сервера
			local on_attach = function(client, bufnr)
				-- Настройки привязки клавиш только к текущему буферу
				local opts = { buffer = bufnr }

				-- ============================================
				-- ОСНОВНЫЕ ГОРЯЧИЕ КЛАВИШИ ДЛЯ LSP
				-- ============================================

				-- gd - Go to Definition: перейти к определению символа
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				-- K - Hover: показать информацию о символе под курсором
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover({
						border = "rounded", -- Скругленная рамка
						max_width = 80, -- Максимальная ширина
						max_height = 20, -- Максимальная высота
					})
				end, opts)

				-- gr - Go to References: найти все использования символа
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

				-- <leader>rn - Rename: переименовать символ
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				-- <leader>ca - Code Action: действия с кодом (исправить, рефакторинг)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				-- ============================================
				-- ГОРЯЧИЕ КЛАВИШИ ДЛЯ РАБОТЫ С ОШИБКАМИ
				-- ============================================

				-- <leader>e - Показать ошибку под курсором в плавающем окне
				vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)

				-- [d - Перейти к предыдущей ошибке
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				-- ]d - Перейти к следующей ошибке
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				-- <leader>q - Открыть список всех ошибок в quickfix окне
				vim.keymap.set("n", "<leader>q", function()
					vim.diagnostic.setqflist({
						open = true, -- Автоматически открыть окно
						title = "Диагностика", -- Заголовок окна
						severity_sort = true, -- Сортировка по важности
					})
				end, opts)

				-- ============================================
				-- ДОПОЛНИТЕЛЬНЫЕ ПОЛЕЗНЫЕ КЛАВИШИ
				-- ============================================

				-- gi - Go to Implementation: перейти к реализации интерфейса
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

				-- <leader>D - Go to Type Definition: перейти к определению типа
				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

				-- <leader>fm - Format file: отформатировать файл (через conform.nvim)
				vim.keymap.set("n", "<leader>fm", function()
					require("conform").format() -- Используем conform.nvim для форматирования
				end, opts)

				-- ============================================
				-- АВТОМАТИЧЕСКИЙ ПОКАЗ ОШИБОК ПРИ НАВЕДЕНИИ КУРСОРА
				-- ============================================
				local function show_diagnostic_on_hover()
					-- Получаем диагностику для текущей строки
					local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
					-- Если есть ошибки в текущей строке - показать их
					if #diagnostics > 0 then
						vim.diagnostic.open_float(nil, {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = "rounded",
							source = "always",
							prefix = function(diagnostic)
								local icons = {
									Error = " ",
									Warn = " ",
									Info = " ",
									Hint = "󰌵 ",
								}
								return icons[diagnostic.severity] or " "
							end,
							scope = "cursor",
							max_width = 80,
							max_height = 20,
						})
					end
				end

				-- Автоматически показывать ошибки при удержании курсора
				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = bufnr,
					callback = show_diagnostic_on_hover,
				})
			end

			-- ============================================
			-- НАСТРОЙКА LUA_LS (LUA LANGUAGE SERVER)
			-- ============================================
			vim.lsp.config("lua_ls", {
				capabilities = capabilities, -- Возможности для автодополнения
				on_attach = on_attach, -- Общая функция для горячих клавиш
				settings = {
					Lua = {
						-- Диагностика: какие глобальные переменные считать валидными
						diagnostics = {
							globals = { "vim" }, -- Не считать 'vim' ошибкой
						},
						-- Форматирование: отключено, используем stylua через conform.nvim
						format = { enable = false },
					},
				},
			})

			-- ============================================
			-- НАСТРОЙКА GOPLS (GO LANGUAGE SERVER)
			-- ============================================
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				on_attach = on_attach,
				-- root_markers: файлы для поиска корня проекта
				root_markers = { "go.mod", ".git", "go.work" },
				settings = {
					gopls = {
						gofumpt = true, -- Использовать строгий форматтер gofumpt
						staticcheck = true, -- Включить статический анализ кода
						usePlaceholders = true, -- Автозаполнение аргументов функций
						completeUnimported = true, -- Автодополнение неимпортированных пакетов
						-- Анализаторы кода
						analyses = {
							unusedparams = true, -- Проверка неиспользуемых параметров
							unusedvariable = true, -- Проверка неиспользуемых переменных
						},
						-- Подсказки в коде (inlay hints)
						hints = {
							assignVariableTypes = true, -- Типы переменных
							compositeLiteralFields = true, -- Поля структур
							constantValues = true, -- Значения констант
							functionTypeParameters = true, -- Параметры функций
							parameterNames = true, -- Имена параметров
							rangeVariableTypes = true, -- Типы в range циклах
						},
					},
				},
			})

			-- ============================================
			-- НАСТРОЙКА TS_LS (TYPESCRIPT LANGUAGE SERVER)
			-- ============================================
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				-- root_markers: файлы для поиска корня проекта
				root_markers = {
					"package.json", -- npm/Node.js проект
					"tsconfig.json", -- TypeScript проект
					"jsconfig.json", -- JavaScript проект
					".git", -- Git репозиторий
				},
			})

			-- ============================================
			-- ВКЛЮЧЕНИЕ LSP СЕРВЕРОВ
			-- ============================================
			vim.lsp.enable({
				"lua_ls", -- Lua Language Server
				"gopls", -- Go Language Server
				"ts_ls", -- TypeScript Language Server
			})
		end,
	},
}
