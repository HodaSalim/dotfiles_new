return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require "dap"
    dap.adapters.ruby = function(callback, config)
      callback {
        type = "server",
        host = config.server or "127.0.0.1",
        port = config.port or 38698,
        executable = {
          command = "bundle",
          args = {
            "exec",
            "rdbg",
            "-n",
            "--open",
            "--port",
            config.port or "38698",
            "-c",
            "--",
            config.command or "rails",
            unpack(config.args or { "server" }),
          },
        },
      }
    end

    dap.configurations.ruby = {
      {
        type = "ruby",
        name = "Debug Rails Server",
        request = "attach",
        port = 38698,
        server = "127.0.0.1",
        options = {
          source_filetype = "ruby",
        },
        localfs = true,
        waiting = 1000,
      },
      {
        type = "ruby",
        name = "Debug RSpec (current file)",
        request = "attach",
        port = 38698,
        server = "127.0.0.1",
        command = "rspec",
        args = function() return { vim.fn.expand "%:p" } end,
        localfs = true,
      },
    }
  end,
}
