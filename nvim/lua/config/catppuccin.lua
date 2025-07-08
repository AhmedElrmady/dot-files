return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    transparent_background = true,
    integrations = {
      telescope = true,
      treesitter = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "underdotted" },
          warnings = { "underdashed" },
          information = { "underline" },
        },
      },
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      which_key = true,
      indent_blankline = { enabled = true },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
