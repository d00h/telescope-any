# Idea 

To make the behavior of the [telescope](https://github.com/nvim-telescope/telescope.nvim) plugin for Neovim slightly more similar to the command palette of the Sublime editor.

[ScreenCast](https://asciinema.org/a/PE3iAhS7ofZ3zTPizrwMKCr2r)

# Install 

```lua
plugins.register({
  url = "https://github.com/d00h/telescope-any",
  config = function()
    local opts = {} -- or user
    local telescope_any = require("telescope-any").create_telescope_any(opts)
    -- vim.api.nvim_create_user_command("TelescopeAny", telescope_any, { nargs = 0 })
    vim.api.nvim_set_keymap("n", "<c-space>", "", {
      noremap = true,
      silent = true,
      callback = telescope_any,
    })
  end
})
```

# Configuration by default 

```lua
  local builtin = require("telescope.builtin")
  return {
    pickers = {
      [":"] = builtin.current_buffer_fuzzy_find,
      ["/"] = builtin.live_grep,

      ["m "] = builtin.marks,
      ["q "] = builtin.quickfix,
      ["l "] = builtin.loclist,
      ["j "] = builtin.jumplist,

      ["man "] = builtin.man_pages,
      ["options "] = builtin.vim_options,
      ["keymaps "] = builtin.keymaps,

      ["colorscheme "] = builtin.colorscheme,
      ["colo "] = builtin.colorscheme,

      ["com "] = builtin.commands,
      ["command "] = builtin.commands,

      ["au "] = builtin.autocommands,
      ["autocommand "] = builtin.autocommands,

      ["highlight "] = builtin.highlights,
      ["hi "] = builtin.highlights,

      ["ctags "] = builtin.current_buffer_tags,

      ["o "] = builtin.oldfiles,
      ["b "] = builtin.buffers,

      ["gs "] = builtin.git_status,
      ["gb "] = builtin.git_branches,
      ["gc "] = builtin.git_commits,

      ["d "] = builtin.diagnostics,
      ["@"] = builtin.lsp_document_symbols,

      [""] = builtin.find_files,
    },
```
