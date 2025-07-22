-- LazyVim plugin for content extraction
-- Place this in ~/.config/nvim/lua/plugins/content-extraction.lua

return {
  "content-extraction",
  dir = "/home/gray/Documents/Second-Brain/My-Virtual-Brain/Scripts", -- Use local directory
  name = "content-extraction",
  config = function()
    -- Configuration
    local config = {
      scripts_path = "/home/gray/Documents/Second-Brain/My-Virtual-Brain/Scripts",
      unsorted_path = "/home/gray/Documents/Second-Brain/My-Virtual-Brain/00.Notes/01.Literature-Notes/00.Syncs/Unsorted",
    }

    -- Extract URL to new file
    local function extract_url()
      local url = vim.fn.input("Enter URL to extract: ")
      if url == "" then
        vim.notify("No URL provided")
        return
      end

      vim.notify("Extracting content from: " .. url)

      local cmd = string.format('cd "%s" && python3 extract_single_url.py "%s"', config.scripts_path, url)

      -- Run command and handle result
      vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and #data > 0 then
            local content = table.concat(data, "\n")
            if content ~= "" and not content:match("^Error:") then
              -- Get title for filename
              local title_cmd =
                string.format('cd "%s" && python3 extract_single_url.py "%s" --title-only', config.scripts_path, url)
              local title_job = vim.fn.jobstart(title_cmd, {
                stdout_buffered = true,
                on_stdout = function(_, title_data)
                  if title_data and #title_data > 0 then
                    local title = table.concat(title_data, ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
                    local sanitized_title = title:gsub("[^%w%s]", ""):gsub("%s+", " "):sub(1, 150)
                    local filename = sanitized_title .. ".md"
                    local filepath = config.unsorted_path .. "/" .. filename

                    -- Write file
                    local file = io.open(filepath, "w")
                    if file then
                      file:write(content)
                      file:close()
                      vim.cmd("edit " .. vim.fn.fnameescape(filepath))
                      vim.notify("✓ Content extracted: " .. filename)
                    end
                  end
                end,
              })
            end
          end
        end,
        on_stderr = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= "" and not line:match("Successfully installed") then
                vim.notify("Error: " .. line, vim.log.levels.ERROR)
              end
            end
          end
        end,
      })
    end

    -- Process sync files
    local function process_syncs()
      vim.notify("Processing Raindrop sync files...")

      local cmd = string.format(
        'cd "%s" && python3 raindrop_auto_extract.py "%s" --scan-only',
        config.scripts_path,
        config.unsorted_path
      )

      vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line ~= "" then
                print(line)
              end
            end
          end
        end,
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("✓ Sync processing complete!")
          else
            vim.notify("✗ Sync processing failed", vim.log.levels.ERROR)
          end
        end,
      })
    end

    -- Extract from current buffer
    local function extract_here()
      local url = vim.fn.expand("<cWORD>")

      if not url:match("^https?://") then
        local line = vim.fn.getline(".")
        url = line:match("(https?://[%w%p]+)")

        if not url then
          vim.notify("No URL found. Place cursor on URL")
          return
        end
      end

      vim.notify("Extracting: " .. url)

      local cmd = string.format('cd "%s" && python3 extract_single_url.py "%s"', config.scripts_path, url)

      vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and #data > 0 then
            local content = table.concat(data, "\n")
            if content ~= "" then
              local current_line = vim.fn.line(".")
              local lines = vim.split(content, "\n")
              vim.fn.append(current_line, { "" })
              vim.fn.append(current_line + 1, "## Extracted Content")
              vim.fn.append(current_line + 2, "")
              vim.fn.append(current_line + 3, lines)
              vim.notify("✓ Content extracted and inserted")
            end
          end
        end,
      })
    end

    -- Commands
    vim.api.nvim_create_user_command("ExtractURL", extract_url, { desc = "Extract URL to new file" })
    vim.api.nvim_create_user_command("ProcessSyncs", process_syncs, { desc = "Process Raindrop sync files" })
    vim.api.nvim_create_user_command("ExtractHere", extract_here, { desc = "Extract URL from buffer" })

    -- Keymaps
    vim.keymap.set("n", "<leader>eu", extract_url, { desc = "Extract URL" })
    vim.keymap.set("n", "<leader>es", process_syncs, { desc = "Process Syncs" })
    vim.keymap.set("n", "<leader>eh", extract_here, { desc = "Extract Here" })

    vim.notify("Content extraction plugin loaded!")
  end,
}
