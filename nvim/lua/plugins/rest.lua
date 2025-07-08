return {
  "rest-nvim/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  ft = { "http" },
  config = function()
    require("rest-nvim").setup({
      result_split_horizontal = false,
      skip_ssl_verification = false,
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        show_url = true,
        show_http_info = true,
        formatters = {
          json = "jq", -- this enables jq formatting for application/json
        },
        show_headers = true,
      },
    })

    -- Keymaps
    --vim.keymap.set("n", "<leader>rr", ":Rest run<CR>", { desc = "Run HTTP request" })
    --vim.keymap.set("n", "<leader>rl", ":Rest last<CR>", { desc = "Run last HTTP request" })
    --vim.keymap.set("n", "<leader>ro", ":Rest open<CR>", { desc = "Open last HTTP result" })

    local keymap = vim.keymap.set
    local opts = { noremap = true, silent = true }

    keymap("n", "<leader>rr", ":Rest run<CR>", vim.tbl_extend("force", opts, { desc = "Run request under cursor" }))
    keymap("n", "<leader>rR", ":Rest run ", vim.tbl_extend("force", opts, { desc = "Run named request" })) -- will wait for user input
    keymap("n", "<leader>rl", ":Rest last<CR>", vim.tbl_extend("force", opts, { desc = "Run last request" }))
    keymap("n", "<leader>ro", ":Rest open<CR>", vim.tbl_extend("force", opts, { desc = "Open result pane" }))
    keymap("n", "<leader>rs", ":Rest env show<CR>", vim.tbl_extend("force", opts, { desc = "Show current .env" }))
    keymap("n", "<leader>re", ":Rest env select<CR>", vim.tbl_extend("force", opts, { desc = "Select .env file" }))
    keymap("n", "<leader>rE", ":Rest env set ", vim.tbl_extend("force", opts, { desc = "Set .env manually" })) -- will wait for input
    keymap("n", "<leader>rc", ":Rest cookies<CR>", vim.tbl_extend("force", opts, { desc = "Edit cookies file" }))
    keymap("n", "<leader>rg", ":Rest logs<CR>", vim.tbl_extend("force", opts, { desc = "Open logs file" }))

    vim.keymap.set("v", "<leader>rj", function()
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")

      -- Get selected lines
      local lines = vim.fn.getline(start_pos[2], end_pos[2])
      local text = table.concat(lines, "\n")

      -- Pipe it through jq
      local handle = io.popen("echo " .. vim.fn.shellescape(text) .. " | jq .")
      if not handle then
        vim.notify("Failed to run jq", vim.log.levels.ERROR)
        return
      end
      local result = handle:read("*a")
      handle:close()

      -- Open in new vertical split preview
      vim.cmd("vsplit")
      vim.cmd("enew")
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
      vim.bo.filetype = "json"
      vim.bo.bufhidden = "wipe"
    end, { desc = "Format selected JSON with jq" })
  end,
}
