-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  { import = "astrocommunity.workflow.bad-practices-nvim" },
  { import = "astrocommunity.recipes.disable-tabline" },
  { import = "astrocommunity.recipes.picker-nvchad-theme" },
  -- import/override with your plugins folder
}
