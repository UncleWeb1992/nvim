return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Загрузи сниппеты
      require("luasnip.loaders.from_vscode").lazy_load()
      
      -- Кастомные иконки (без пробелов в конце)
      local kind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
        Copilot = "",
      }
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            scrollbar = false,
          },
          documentation = {
            border = "single",
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            max_width = 80,
            max_height = 12,
          },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            -- Иконки (без пробелов после иконок)
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind] or "")
            
            -- Меню с источником
            vim_item.menu = ({
              nvim_lsp = "  ",
              nvim_lua = "  ",
              luasnip = " 󰆐 ",
              buffer = " 󰾷 ",
              path = " 󰉖 ",
              emoji = " 󰱺 ",
              git = " 󰊢 ",
            })[entry.source.name] or ""
            
            -- Убираем дублирование названий
            vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
            
            return vim_item
          end,
        },
        mapping = {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp", priority = 100 },
          { name = "luasnip", priority = 90 },
          { name = "buffer", priority = 70 },
          { name = "path", priority = 60 },
          { name = "emoji", priority = 40 },
        },
        experimental = {
          ghost_text = {
            hl_group = "Comment",
          },
        },
      })
      
      -- Настройки для командной строки
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
      
      -- Стили для красивого вида
      vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#c586c0", italic = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#d4d4d4" })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#569cd6", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#569cd6", bold = true })
    end,
  },
  
  -- Автоматические скобки и кавычки
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })
      
      -- Интеграция с cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
}
