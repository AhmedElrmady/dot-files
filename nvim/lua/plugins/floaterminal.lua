return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]], -- Default: Ctrl+\
      direction = "float", -- Or "horizontal", "vertical"
      float_opts = {
        border = "rounded",
        winblend = 10,
      },
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
    })

    -- Optional: keymaps for extra terminals
    vim.keymap.set("n", "<leader>tf", function()
      require("toggleterm.terminal").Terminal
        :new({
          direction = "float",
        })
        :toggle()
    end, { desc = "Toggle Float Term" })

    vim.keymap.set("n", "<leader>th", function()
      require("toggleterm.terminal").Terminal
        :new({
          direction = "horizontal",
          size = 15,
        })
        :toggle()
    end, { desc = "Toggle Horizontal Term" })
  end,
}
