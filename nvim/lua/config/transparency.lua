local function set_transparent()
  vim.cmd([[
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NormalNC guibg=NONE ctermbg=NONE
    highlight VertSplit guibg=NONE
    highlight StatusLine guibg=NONE
    highlight StatusLineNC guibg=NONE
    highlight LineNr guibg=NONE
    highlight Folded guibg=NONE
    highlight Pmenu guibg=NONE
    highlight TelescopeNormal guibg=NONE
    highlight TelescopeBorder guibg=NONE
    highlight TelescopePromptNormal guibg=NONE
    highlight TelescopePromptBorder guibg=NONE
    highlight TelescopePromptTitle guibg=NONE
    highlight TelescopePreviewTitle guibg=NONE
    highlight TelescopeResultsTitle guibg=NONE
  ]])
end

-- Apply transparency now
set_transparent()

-- Re-apply after colorscheme changes (to override)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparent,
})
