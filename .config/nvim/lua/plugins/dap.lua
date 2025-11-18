return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      -- Gracefully handle not having a python virtual env active.
      -- In general this debugging should be re-thought so we can support multiple debuggers.
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F12>", dap.step_out)
      vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<Leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "Restart" })

      vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Stop debugging" })
      vim.keymap.set("n", "<Leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
      vim.keymap.set("n", "<Leader>dR", function()
        dapui.open({ reset = true })
      end, { desc = "Reset DAP UI layout" })

      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
