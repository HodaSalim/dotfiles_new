return {
  n = {
    ["<leader>bp"] = {
      function()
        local path = vim.fn.expand "%:."
        vim.fn.setreg("+", path)
        vim.notify("Copied path:\n" .. path)
      end,
      desc = "Copy buffer full path",
    },
  },
}
