return {
	{
		-- conform.nvim - плагин для автоматического форматирования кода
		-- Автор: Steve Arc (stevearc)
		-- GitHub: https://github.com/stevearc/conform.nvim
		-- Аналог: Prettier для Neovim, замена null-ls
		"stevearc/conform.nvim",

		-- Зависимости: нужен Mason для управления форматтерами
		dependencies = { "williamboman/mason.nvim" },

		-- Функция настройки плагина
		config = function()
			require("conform").setup({
				-- ============================================
				-- НАСТРОЙКА ФОРМАТТЕРОВ ДЛЯ РАЗНЫХ ТИПОВ ФАЙЛОВ
				-- ============================================
				formatters_by_ft = {
					-- Lua: использует stylua (форматтер для Lua)
					-- Установите: cargo install stylua или через Mason
					lua = { "stylua" },

					-- Go: использует gofmt (стандартный форматтер Go)
					-- и goimports (управляет импортами + форматирование)
					-- Установите: они идут с Go (go install golang.org/x/tools/cmd/goimports)
					go = { "gofmt", "goimports" },

					-- JavaScript: использует Prettier
					-- Установите: npm install -g prettier или через Mason
					javascript = { "prettier" },

					-- TypeScript: также использует Prettier
					typescript = { "prettier" },

					-- React с JavaScript: Prettier с поддержкой JSX
					javascriptreact = { "prettier" },

					-- React с TypeScript: Prettier с поддержкой TSX
					typescriptreact = { "prettier" },

					-- JSON: Prettier отлично форматирует JSON
					json = { "prettier" },

					-- CSS: Prettier для стилей
					css = { "prettier" },

					-- HTML: Prettier для разметки
					html = { "prettier" },

					-- ============================================
					-- МОЖНО ДОБАВИТЬ ДРУГИЕ ЯЗЫКИ:
					-- ============================================
					-- python = { "black", "isort" },      -- Black + сортировка импортов
					-- markdown = { "prettier" },          -- Markdown
					-- yaml = { "prettier" },              -- YAML
					-- java = { "google-java-format" },    -- Java
					-- rust = { "rustfmt" },               -- Rust (идет с Rust)
					-- sql = { "sqlfmt" },                 -- SQL
					-- sh = { "shfmt" },                   -- Shell scripts
					-- c = { "clang-format" },             -- C/C++
					-- cpp = { "clang-format" },           -- C++
					-- php = { "php-cs-fixer" },           -- PHP
				},

				-- ============================================
				-- НАСТРОЙКА АВТОФОРМАТИРОВАНИЯ ПРИ СОХРАНЕНИИ
				-- ============================================
				format_on_save = {
					-- Таймаут в миллисекундах (чтобы не блокировать сохранение)
					timeout_ms = 500,

					-- Использовать ли LSP форматирование если форматтер не найден
					-- false = не использовать, true = попробовать LSP форматирование
					lsp_fallback = false,

					-- ============================================
					-- ДОПОЛНИТЕЛЬНЫЕ ОПЦИИ (можно добавить):
					-- ============================================
					-- async = false,           -- Синхронное форматирование
					-- quiet = false,           -- Не показывать уведомления
					-- filter = function(bufnr) -- Фильтр для каких файлов форматировать
					--   local filename = vim.api.nvim_buf_get_name(bufnr)
					--   if vim.bo[bufnr].buftype ~= "" then
					--     return false  -- не форматировать не-file буферы
					--   end
					--   return true
					-- end,
				},

				-- ============================================
				-- ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ :
				-- ============================================
				notify_on_error = true, -- Показывать ошибки форматирования
				log_level = vim.log.levels.WARN, -- Уровень логирования

				-- -- Настройки для форматтеров
				-- formatters = {
				--   prettier = {
				--     prepend_args = { "--single-quote" }, -- Аргументы для Prettier
				--   },
				--   stylua = {
				--     prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
				--   },
				-- },
			})

			-- ============================================
			-- ДОБАВИТЬ ГОРЯЧИЕ КЛАВИШИ:
			-- ============================================
			-- vim.keymap.set({ "n", "v" }, "<leader>cf", function()
			--   require("conform").format()
			-- end, { desc = "Format file" })
			--
			-- -- Или для асинхронного форматирования:
			-- vim.keymap.set("n", "<leader>cf", function()
			--   require("conform").format({ async = true, lsp_fallback = true })
			-- end, { desc = "Format file async" })
		end,
	},
}
