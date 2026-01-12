return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,  -- ⭐ Важно: загружать при старте
    init = function()
      -- Автооткрытие neo-tree при старте
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Ждем немного чтобы все загрузилось
          vim.defer_fn(function()
            -- Проверяем, открыли ли мы директорию (nvim .) или проект
            local should_open_tree = false
            
            if vim.fn.argc() == 0 then
              -- Запустили просто `nvim` - открываем дерево
              should_open_tree = true
            elseif vim.fn.argc() == 1 then
              local stat = vim.loop.fs_stat(vim.fn.argv(0))
              if stat and stat.type == "directory" then
                -- Запустили `nvim .` или `nvim папка`
                should_open_tree = true
              end
            end
            
            if should_open_tree then
              -- Закрываем пустой начальный буфер если он есть
              local bufs = vim.api.nvim_list_bufs()
              for _, buf in ipairs(bufs) do
                if vim.api.nvim_buf_get_name(buf) == "" and 
                   vim.api.nvim_buf_line_count(buf) <= 1 then
                  vim.api.nvim_buf_delete(buf, { force = true })
                end
              end
              
              -- Открываем neo-tree
              vim.cmd("Neotree filesystem reveal left")
            end
          end, 50)
        end,
      })
    end,
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,  -- ⭐ Закрыть Neovim если neo-tree последнее окно
        popup_border_style = "NC",
        enable_git_status = true,
        enable_diagnostics = true,
        window = {
          position = "left",
          width = 35,
          mappings = {
            ["<space>"] = "none",  -- чтобы не конфликтовало с лидером
            ["q"] = "close_window",
            ["<Esc>"] = "close_window",
          },
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        filesystem = {
          hijack_netrw_behavior = "open_default",  -- ⭐ Заменяет netrw по умолчанию
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
            hide_gitignored = false,
          },
          follow_current_file = {
            enabled = true,
          },
          window = {
            mappings = {
              ["h"] = "close_node",
              ["l"] = "open",
              ["o"] = "open",
              ["<CR>"] = "open",
            },
          },
        },
      })
      
      -- Горячая клавиша для переключения дерева
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle NeoTree" })
    end,
  },
}
