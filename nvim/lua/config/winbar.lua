--- Modify the path to only show the last 3 segments.
vim.opt.winbar = "%=%m %{v:lua.Winbar()}"

function _G.Winbar()
  local filepath = vim.fn.expand("%:~:.") -- relative to CWD or home
  local parts = {}
  for part in string.gmatch(filepath, "[^/]+") do
    table.insert(parts, part)
  end
  local len = #parts
  local segments = {}

  for i = math.max(len - 2, 1), len do
    table.insert(segments, parts[i])
  end

  return table.concat(segments, "/")
end
------------------------------------------------------
