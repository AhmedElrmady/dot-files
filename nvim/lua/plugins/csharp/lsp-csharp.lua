-- csharp-ls is lightweight and works well for pure C#.
-- omnisharp has broader support (e.g., .cshtml, Razor syntax, etc.).
-- make sure not to make both active at the same time for the same filetype.
--
--
require("lspconfig.configs.omnisharp")
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      csharp_ls = {
        cmd = { "csharp-ls" },
        filetypes = { "cs" },
        root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git"),
      },
      -- omnisharp = {
      --  filetypes = { "cshtml" },
      --  root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git"),
      --  cmd = { "omnisharp" },
      --},
    },
  },
}
