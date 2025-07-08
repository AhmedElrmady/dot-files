-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("i", "jj", "<Esc>", opts)

-- Splitting
keymap("n", "sh", ":split<CR>", opts)
keymap("n", "sv", ":vsplit<CR>", opts)

-- Select all
keymap("n", "<C-a>", "gg<S-v>G", opts)
