-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec

local function yank_github_link()
  -- Git root
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if not git_root or git_root == "" then
    vim.notify("Not in a git repository", vim.log.levels.ERROR)
    return
  end

  -- File path relative to repo root
  local file = vim.fn.expand("%:p"):gsub("^" .. git_root .. "/", "")

  -- Branch
  local branch = vim.fn.systemlist("git branch --show-current")[1]
  if not branch or branch == "" then branch = "main" end

  -- Remote
  local remote = vim.fn.systemlist("git remote get-url origin")[1]
  if not remote or remote == "" then
    vim.notify("No git remote found", vim.log.levels.ERROR)
    return
  end

  -- Normalize GitHub remote
  remote = remote:gsub("git@github.com:", "https://github.com/"):gsub("%.git$", "")

  -- Line(s)
  local start_line, end_line
  if vim.fn.mode():match "[vV]" then
    start_line = vim.fn.line "v"
    end_line = vim.fn.line "."
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
  else
    start_line = vim.fn.line "."
    end_line = start_line
  end

  -- Anchor
  local anchor
  if start_line == end_line then
    anchor = string.format("#L%d", start_line)
  else
    anchor = string.format("#L%d-L%d", start_line, end_line)
  end
  -- URL
  local url = string.format("%s/blob/%s/%s%s", remote, branch, file, anchor)
  vim.fn.setreg("+", url)
  vim.notify("Copied GitHub link:\n" .. url)
end
return {
  -- Normal + Visual mode mapping
  vim.keymap.set({ "n", "v" }, "<leader>yg", yank_github_link, {
    desc = "Yank GitHub link (line or selection)",
  }),
  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },

  -- == Examples of Overriding Plugins ==

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },

  {
    -- YANK / COPY namespace
    vim.keymap.set("n", "<leader>yp", function()
      local path = vim.fn.expand "%:~:."
      vim.fn.setreg("+", path)
      vim.notify("Copied path:\n" .. path)
    end, { desc = "Yank relative path" }),

    vim.keymap.set("n", "<leader>ya", function()
      local path = vim.fn.expand "%:p"
      vim.fn.setreg("+", path)
      vim.notify("Copied absolute path:\n" .. path)
    end, { desc = "Yank absolute path" }),

    vim.keymap.set("n", "<leader>yl", function()
      local path = vim.fn.expand "%:~:."
      local line = vim.fn.line "."
      local value = string.format("%s:%d", path, line)
      vim.fn.setreg("+", value)
      vim.notify("Copied path + line:\n" .. value)
    end, { desc = "Yank path + line" }),

    vim.keymap.set("n", "<leader>yf", function()
      local name = vim.fn.expand "%:t"
      vim.fn.setreg("+", name)
      vim.notify("Copied filename:\n" .. name)
    end, { desc = "Yank filename" }),

    vim.keymap.set("n", "<leader>yg", function()
      local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
      if not git_root or git_root == "" then
        vim.notify("Not in a git repository", vim.log.levels.ERROR)
        return
      end

      local file = vim.fn.expand("%:p"):gsub("^" .. git_root .. "/", "")
      local branch = vim.fn.systemlist("git branch --show-current")[1] or "main"
      local remote = vim.fn.systemlist("git remote get-url origin")[1]

      if not remote or remote == "" then
        vim.notify("No git remote found", vim.log.levels.ERROR)
        return
      end

      remote = remote:gsub("git@github.com:", "https://github.com/"):gsub("%.git$", "")

      local line = vim.fn.line "."
      local url = string.format("%s/blob/%s/%s#L%d", remote, branch, file, line)

      vim.fn.setreg("+", url)
      vim.notify("Copied GitHub link:\n" .. url)
    end, { desc = "Yank GitHub link" }),
  },
}
