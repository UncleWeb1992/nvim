return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/nvim-cmp",
	},
	config = function()
		local npairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		npairs.setup({
			-- Отключить для определенных файлов
			disable_filetype = { "TelescopePrompt", "vim", "markdown" },

			-- Отключить в визуальном режиме
			disable_in_macro = false,
			disable_in_visualblock = false,
			disable_in_replace_mode = true,

			-- Включить после ввода `$` (для LaTeX)
			enable_check_bracket_line = false,

			-- Настройки игнорирования
			ignored_next_char = "[%w%.]", -- игнорировать если следующий символ буква/точка

			-- Быстрое перемещение
			fast_wrap = {
				map = "<M-e>", -- Alt+e для быстрого перехода
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%)%>%]%)%}%,]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},

			-- Включить деревьят (ts)
			check_ts = true,
			ts_config = {
				lua = { "string" }, -- не закрывать кавычки в строках Lua
				javascript = { "template_string" },
				java = false, -- отключить для Java
			},
		})

		-- Добавить свои правила
		local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
		npairs.add_rules({
			-- Правило для пробелов между скобками
			Rule(" ", " ")
				:with_pair(function(opts)
					local pair = opts.line:sub(opts.col - 1, opts.col)
					return vim.tbl_contains({
						"()",
						"[]",
						"{}",
					}, pair)
				end)
				:with_move(cond.none())
				:with_cr(cond.none())
				:with_del(function(opts)
					local col = vim.api.nvim_win_get_cursor(0)[2]
					local context = opts.line:sub(col - 1, col + 2)
					return vim.tbl_contains({
						"(  )",
						"[  ]",
						"{  }",
					}, context)
				end),
		})

		-- Правило для $ в LaTeX/Math
		npairs.add_rules({
			Rule("$", "$", { "tex", "latex", "markdown" }):with_move(function(opts)
				return opts.char == opts.next_char
			end):with_cr(cond.none()),
		})

		-- Интеграция с cmp (у вас уже есть)
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- Горячие клавиши для управления
		vim.keymap.set("i", "<M-e>", function()
			local autopairs = require("nvim-autopairs")
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "n", false)
			autopairs.fast_wrap()
		end, { desc = "Fast wrap brackets" })
	end,
}
