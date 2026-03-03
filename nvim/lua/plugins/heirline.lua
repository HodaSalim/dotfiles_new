return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local utils = require "heirline.utils"

    local FileName = {
      init = function(self) self.filename = vim.fn.expand "%:~:." end,
      provider = function(self)
        if self.filename == "" then return "[No Name]" end
        return self.filename
      end,
      hl = function()
        if vim.bo.modified then return { fg = utils.get_highlight("DiagnosticWarn").fg, bold = true } end
        return { fg = utils.get_highlight("Directory").fg }
      end,
    }

    -- Insert filename near the left side
    table.insert(opts.statusline, 3, FileName)
  end,
}
