local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

local lazy = require("lazy")

lazy.setup({
  {
    url = "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },
  {
    dir = vim.fn.getcwd(),
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local telescope_any = require("telescope-any").create_telescope_any()
      -- vim.api.nvim_create_user_command("TelescopeAny", telescope_any, { nargs = 0 })
      vim.api.nvim_set_keymap("n", "<c-space>", "", {
        noremap = true,
        silent = true,
        callback = telescope_any,
      })
    end,
  },
})
