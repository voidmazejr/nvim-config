return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    -- prefer the prettierd daemon (faster on save), fall back to prettier if it isn't running
    local prettier = { "prettierd", "prettier", stop_after_first = true }

    conform.setup({
      formatters_by_ft = {
        javascript = prettier,
        typescript = prettier,
        javascriptreact = prettier,
        typescriptreact = prettier,
        svelte = prettier,
        css = prettier,
        html = prettier,
        json = prettier,
        yaml = prettier,
        markdown = prettier,
        graphql = prettier,
        liquid = prettier,
        lua = { "stylua" },
        python = { "isort", "black" },
        java = { "clang-format" },
      },
      formatters = {
        ["clang-format"] = {
          -- 2-space indent, keep `if (...) return;` on one line, roomier column limit
          prepend_args = {
            "--style={BasedOnStyle: Google, IndentWidth: 2, ContinuationIndentWidth: 4, ColumnLimit: 120, AllowShortIfStatementsOnASingleLine: WithoutElse}",
          },
        },
      },
      format_on_save = {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 3000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>mp", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
