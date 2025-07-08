return {
  "jlcrochet/vim-razor", -- for syntax highlighting and indentation
  ft = "cshtml",

  lazy = false,
  priority = 1000,
  config = function()
    vim.filetype.add({
      extension = {
        cshtml = "cshtml",
      },
    })

    -- Ensure .cshtml always uses 'cshtml' filetype, even if plugins try to override it
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.cshtml",
      callback = function()
        vim.bo.filetype = "cshtml"
      end,
    })
  end,
}
