-- Configure Telescope to shorten paths in results
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "polirritmico/telescope-lazy-plugins.nvim" },
  },
  opts = function(_, opts)
    -- Extend default Telescope settings
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      path_display = {
        shorten = function(path)
          local parts = {}
          for part in path:gmatch("[^/\\]+") do
            table.insert(parts, part)
          end
          local len = #parts
          return table.concat({
            parts[len - 2] or "",
            parts[len - 1] or "",
            parts[len] or "",
          }, "/")
        end,
      },
    })

    -- Configure extension
    opts.extensions = opts.extensions or {}
    opts.extensions.lazy_plugins = {
      -- or your lazy_config, show_disabled, etc.
    }

    return opts
  end,
}
