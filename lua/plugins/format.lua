return {
  {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          go = { "gofmt", "goimports" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
        },

        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = false,
        },
      })
    end,
  },
}

