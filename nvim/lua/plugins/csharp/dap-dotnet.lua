return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")

    -- Adapter + config
    dap.adapters.coreclr = {
      type = "executable",
      command = "/usr/local/bin/netcoredbg",
      args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "Launch .NET Project",
        request = "launch",
        program = function()
          local cwd = vim.fn.getcwd()
          local pattern = cwd .. "/**/bin/*/**/*.dll"
          local dlls = vim.fn.glob(pattern, true, true)

          if #dlls == 0 then
            vim.notify("❌ No DLLs found in bin/*/", vim.log.levels.ERROR)
            return ""
          elseif #dlls == 1 then
            return dlls[1]
          else
            -- Build numbered list
            local choices = {}
            for i, path in ipairs(dlls) do
              table.insert(choices, string.format("%d: %s", i, path))
            end

            -- Ask user to choose
            local choice = vim.fn.inputlist(choices)

            -- Return the selected DLL
            if choice >= 1 and choice <= #dlls then
              return dlls[choice]
            else
              vim.notify("❌ Invalid choice. Debug canceled.", vim.log.levels.WARN)
              return ""
            end
          end
        end,
        --program = function()
        -- return vim.fn.input("Path to DLL > ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        --end,
      },
    }

    -- dap-ui
    local dapui = require("dapui")
    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })

    vim.keymap.set("n", "<F5>", function()
      require("dap").continue()
    end, { desc = "Start/Continue Debug" })
    vim.keymap.set("n", "<F10>", function()
      require("dap").step_over()
    end, { desc = "Step Over" })
    vim.keymap.set("n", "<F11>", function()
      require("dap").step_into()
    end, { desc = "Step Into" })
    vim.keymap.set("n", "<F12>", function()
      require("dap").step_out()
    end, { desc = "Step Out" })
    vim.keymap.set("n", "<Leader>b", function()
      require("dap").toggle_breakpoint()
    end, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>B", function()
      require("dap").set_breakpoint()
    end)
    vim.keymap.set("n", "<Leader>dp", function()
      require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end)
    vim.keymap.set("n", "<Leader>dr", function()
      require("dap").repl.open()
    end)
    vim.keymap.set("n", "<Leader>dl", function()
      require("dap").run_last()
    end)
    vim.keymap.set("n", "<Leader>dh", function()
      require("dap.ui.widgets").hover()
    end)
    vim.keymap.set("n", "<Leader>dp", function()
      require("dap.ui.widgets").preview()
    end)
    vim.keymap.set("n", "<Leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end)
    vim.keymap.set("n", "<Leader>ds", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end)
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debugger UI" })
  end,
}
